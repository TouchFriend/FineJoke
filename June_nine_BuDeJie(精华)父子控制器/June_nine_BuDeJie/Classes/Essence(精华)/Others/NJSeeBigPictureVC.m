//
//  NJSeeBigPictureVC.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/29.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJSeeBigPictureVC.h"
#import "NJTopic.h"
#import "UIImageView+NJDownload.h"
#import <Photos/Photos.h>
#import <SVProgressHUD.h>
@interface NJSeeBigPictureVC () <UIScrollViewDelegate>
- (IBAction)backBtnClick:(UIButton *)sender;
- (IBAction)saveBtnClick:(UIButton *)sender;
/********* scrollView *********/
@property(nonatomic,weak)UIScrollView * scrollView;
/********* 图片 *********/
@property(nonatomic,weak)UIImageView * imageView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
/********* 获取App对应的相册 *********/
- (PHAssetCollection *)createdCollection;
/********* 将图片保存到相机胶卷中 *********/
- (PHFetchResult<PHAsset *> *)saveImage:(UIImage *)image;
@end

@implementation NJSeeBigPictureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置scrollView
    [self setupScrollView];
    //添加手势
    [self setupGestureRecognizer];
    
}
#pragma mark - 添加手势
- (void)setupGestureRecognizer
{
    //1.添加点击手势
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backBtnClick:)];
    [self.scrollView addGestureRecognizer:tapGesture];
}
#pragma mark - 添加scrollView
- (void)setupScrollView
{
    UIScrollView * scrollView = [[UIScrollView alloc]init];
    scrollView.frame = [UIScreen mainScreen].bounds;
    [self.view insertSubview:scrollView atIndex:0];
    self.scrollView = scrollView;
    //图片缩放
    CGFloat maxScale = self.topic.width / self.scrollView.NJ_width;
    if(maxScale > 1)
    {
        scrollView.maximumZoomScale = maxScale;
        scrollView.delegate = self;
    }
    [self setupImage];
}
#pragma mark - 设置图片
- (void)setupImage
{
    UIImageView * imageView = [[UIImageView alloc]init];
    self.imageView = imageView;
    imageView.NJ_width = self.scrollView.NJ_width;
    //等比例缩放
    imageView.NJ_height = imageView.NJ_width * self.topic.height / self.topic.width;
    imageView.NJ_x = 0;
    if(imageView.NJ_height > NJScreenH)//高度超过一个屏幕
    {
        imageView.NJ_y = 0;
        self.scrollView.contentSize = CGSizeMake(0, imageView.NJ_height);//设置滚动范围
    }
    else
    {
        imageView.NJ_centerY = self.scrollView.NJ_centerY;//图片居中
    }
    [self.scrollView addSubview:imageView];
    //下载图片
    [imageView setOriginImageWithURL:self.topic.image1 setThumbnailImageWithURL:self.topic.image0 placeholder:nil complete:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(imageView == nil)
        {
            return ;
        }
        self.saveBtn.enabled = YES;
    }];
    
}
- (IBAction)backBtnClick:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 将图片保存到相机胶卷中
- (PHFetchResult<PHAsset *> *)saveImage:(UIImage *)image
{
    NSError * error;
    __block NSString * localIdentifier;
    //同步执行的
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        localIdentifier = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
    } error:&error];
    if(error != nil)
    {
        return nil;
    }
    //获取新添加到相册的图片
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[localIdentifier] options:nil];
}
#pragma mark - 获取App对应的相册
- (PHAssetCollection *)createdCollection
{
    //获取app的名称
    NSString * appTitle = [NSBundle mainBundle].infoDictionary[(__bridge NSString *)kCFBundleNameKey];
    //获取所有的用户自定义的相册
    PHFetchResult<PHAssetCollection *> * collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    //1.查询app对应的相册是否存在
    for (PHAssetCollection * collection in collections) {
        if([collection.localizedTitle isEqualToString:appTitle])
        {
            //返回查找到的相册
            return collection;
        }
    }
    NSError * error;
    __block NSString *  localIdentifier;
    //2.创建app对应的相册
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        localIdentifier = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:appTitle].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    if(error != nil)
    {
        return nil;
    }
    //通过相册的唯一标识获取App对应的相册
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[localIdentifier] options:nil].firstObject;
    
    
}

#pragma mark - 点击保存按钮
- (IBAction)saveBtnClick:(UIButton *)sender
{
    //得到授权状态
    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
    // 请求\检查访问权限 :
    // 如果用户还没有做出选择，会自动弹框，用户对弹框做出选择后，才会调用block
    // 如果之前已经做过选择，会直接执行block

    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_sync(dispatch_get_main_queue(), ^{//放到主线程中
            if(status == PHAuthorizationStatusAuthorized)//用户允许当前App访问相册
            {
                [self saveImageToPhotos];//保存图片
            }
            else if(status == PHAuthorizationStatusDenied)//用户拒绝当前App访问相册
            {
                if(oldStatus != PHAuthorizationStatusNotDetermined)//如果就得授权状态不是未决定
                {
                    [SVProgressHUD showErrorWithStatus:@"请去设置，允许访问相册"];
                }
            }
            else if(status == PHAuthorizationStatusRestricted)//无法访问相册
            {
                [SVProgressHUD showErrorWithStatus:@"因系统原因，无法访问相册"];
            }
        });
        
    }];
}
#pragma mark - 保存图片到Photos
- (void)saveImageToPhotos
{
    //1.将图片保存到相机胶卷
    PHFetchResult<PHAsset *> * fetchResult = [self saveImage:self.imageView.image];
    if(fetchResult == nil)
    {
        [SVProgressHUD showSuccessWithStatus:@"保存失败"];
        return;
    }
    //2.创建App对应的相册
    PHAssetCollection * collection = self.createdCollection;
    if(collection == nil)
    {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
        return;
    }
    //3.将新照片添加到对应的App相册中。
    NSError * error;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest * collectionRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
        [collectionRequest insertAssets:fetchResult atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];
    if(error == nil)
    {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    }

}
#pragma mark - UIScrollViewDelegate方法
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
@end
