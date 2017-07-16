//
//  NJTopicVoiceView.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/26.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJTopicVoiceView.h"
#import <UIImageView+WebCache.h>
#import <AFNetworking.h>
#import "NJTopic.h"
#import "UIImageView+NJDownload.h"
#import "NJSeeBigPictureVC.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
@interface NJTopicVoiceView ()
@property (weak, nonatomic) IBOutlet UIImageView *topicImageV;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderImageV;

@end
@implementation NJTopicVoiceView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playVoice)];
    [self addGestureRecognizer:tapGesture];
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
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",topic.voicetime / 60,topic.voicetime % 60];
}
#pragma mark - 点击查看大图
- (void)playVoice
{
    AVPlayer * player = [AVPlayer playerWithURL:[NSURL URLWithString:self.topic.voiceuri]];
    AVPlayerViewController * playerVC = [[AVPlayerViewController alloc]init];
    playerVC.player = player;
    [self.window.rootViewController presentViewController:playerVC animated:YES completion:nil];
    [player play];
}
@end
