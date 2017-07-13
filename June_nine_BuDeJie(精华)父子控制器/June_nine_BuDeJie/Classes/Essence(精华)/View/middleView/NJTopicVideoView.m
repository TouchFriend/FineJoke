//
//  NJTopicVideoView.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/26.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJTopicVideoView.h"
#import "NJTopic.h"
#import <UIImageView+WebCache.h>
#import <AFNetworking.h>
#import "NJTopic.h"
#import "UIImageView+NJDownload.h"
@interface NJTopicVideoView ()
@property (weak, nonatomic) IBOutlet UIImageView *topicImageV;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderImageV;

@end
@implementation NJTopicVideoView
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
    }];
    
    //播放量r
    if(topic.playcount > 10000)//超一万
    {
        NSString * playcountStr = [NSString stringWithFormat:@"%.1lf万播放",topic.playcount / 10000.0];
        self.playCountLabel.text = [playcountStr stringByReplacingOccurrencesOfString:@".0" withString:@""];//去掉.0
    }
    else
    {
        self.playCountLabel.text = [NSString stringWithFormat:@"%ld播放",topic.playcount];
    }
    //播放时长
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",topic.videotime / 60,topic.videotime % 60];
}

@end
