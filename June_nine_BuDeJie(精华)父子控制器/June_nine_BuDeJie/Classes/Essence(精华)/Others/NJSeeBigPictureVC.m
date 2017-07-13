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
@interface NJSeeBigPictureVC () <UIScrollViewDelegate>
- (IBAction)backBtnClick:(UIButton *)sender;
- (IBAction)saveBtnClick:(UIButton *)sender;
/********* scrollView *********/
@property(nonatomic,weak)UIScrollView * scrollView;
/********* 图片 *********/
@property(nonatomic,weak)UIImageView * imageView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
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

- (IBAction)saveBtnClick:(UIButton *)sender
{
    /*
     'This method can only be called from inside of -[PHPhotoLibrary performChanges:completionHandler:] or -[PHPhotoLibrary performChangesAndWait:error:]'
     */
    //    NSError * error;
    //    //同步执行的
    //    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
    //        [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image];
    //    } error:&error];
    //    if(error == nil)
    //    {
    //        NJLog(@"success");
    //    }
    //    else
    //    {
    //        NJLog(@"error");
    //    }
    //异步执行的
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if(error == nil)
        {
            NJLog(@"success");
        }
        else
        {
            NJLog(@"error");
        }
    }];

    
}
#pragma mark - UIScrollViewDelegate方法
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
@end
