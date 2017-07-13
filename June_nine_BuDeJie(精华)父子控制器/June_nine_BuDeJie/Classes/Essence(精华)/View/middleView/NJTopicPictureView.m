//
//  NJTopicPictureView.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/26.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJTopicPictureView.h"
#import <UIImageView+WebCache.h>
#import "NJTopic.h"
#import "UIImageView+NJDownload.h"
#import <UIImage+GIF.h>
@interface NJTopicPictureView ()
@property (weak, nonatomic) IBOutlet UIImageView *topicImageV;
@property (weak, nonatomic) IBOutlet UIImageView *gifImageV;
@property (weak, nonatomic) IBOutlet UIButton *seeBigBtn;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderImageV;
@end

@implementation NJTopicPictureView
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
}
- (void)setTopic:(NJTopic *)topic
{
    _topic = topic;
    self.placeholderImageV.hidden = NO;
    [self.topicImageV setOriginImageWithURL:topic.image1 setThumbnailImageWithURL:topic.image0 placeholder:[UIImage imageNamed:@"side"] complete:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if(image == nil)
        {
            return ;
        }
        self.placeholderImageV.hidden = YES;//图片下载成功
        if(topic.isBigPicture)//处理超长图片的大小
        {
            CGFloat imageW = self.topicImageV.NJ_width;
            CGFloat imageH = imageW * topic.height / topic.width;
            
            //开启图像上下文
            UIGraphicsBeginImageContext(CGSizeMake(imageW, imageH));
            //绘制图片到上下文
            [self.topicImageV.image drawInRect:CGRectMake(0, 0, imageW, imageH)];
            //获取当前上下文图片
            self.topicImageV.image =  UIGraphicsGetImageFromCurrentImageContext();
            //关闭图像上下文
            UIGraphicsEndImageContext();
        }

    }];
    //1.是否隐藏动态图标志
//    self.gifImageV.hidden = ![topic.image1.lowercaseString hasSuffix:@"gif"];
    self.gifImageV.hidden = !topic.is_gif;
    //是否是大图
    if(topic.isBigPicture)
    {
        self.seeBigBtn.hidden = NO;
        self.topicImageV.contentMode = UIViewContentModeTop;
        self.topicImageV.clipsToBounds = YES;
    }
    else
    {
        self.seeBigBtn.hidden = YES;
        self.topicImageV.contentMode = UIViewContentModeScaleToFill;
        self.topicImageV.clipsToBounds = NO;
    }
}

@end
