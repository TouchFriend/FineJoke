//
//  NJTopicCell.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/24.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJTopicCell.h"
#import "NJTopic.h"
#import <UIImageView+WebCache.h>

#import "NJTopicPictureView.h"
#import "NJTopicVideoView.h"
#import "NJTopicVoiceView.h"
#import "UIImageView+NJDownload.h"
//profile_image name passtime text ding cai repost comment
@interface NJTopicCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *myTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *dingBtn;
@property (weak, nonatomic) IBOutlet UIButton *caiBtn;
@property (weak, nonatomic) IBOutlet UIButton *repostBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIView *topCommentView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentContentLabel;

/*中间控件*/
/********* 图片 *********/
@property(nonatomic,weak)NJTopicPictureView * pictureView;
/********* 声音 *********/
@property(nonatomic,weak)NJTopicVoiceView * voiceView;
/********* 视频 *********/
@property(nonatomic,weak)NJTopicVideoView * videoView;
@end
@implementation NJTopicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
}
//懒加载
- (NJTopicPictureView *)pictureView
{
    if(_pictureView == nil)
    {
        NJTopicPictureView * pictureView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NJTopicPictureView class]) owner:nil options:nil] firstObject];
        _pictureView = pictureView;
        [self addSubview:pictureView];
    }
    return _pictureView;
}
- (NJTopicVoiceView *)voiceView
{
    if(_voiceView == nil)
    {
        NJTopicVoiceView * voiceView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NJTopicVoiceView class]) owner:nil options:nil] firstObject];
        _voiceView = voiceView;
        [self addSubview:voiceView];
    }
    return _voiceView;
}
- (NJTopicVideoView *)videoView
{
    if(_videoView == nil)
    {
        NJTopicVideoView * videoView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NJTopicVideoView class]) owner:nil options:nil] firstObject];
        _videoView = videoView;
        [self addSubview:videoView];
    }
    return _videoView;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    //设置中间控件的frame
    switch (self.topic.type) {
        case NJTopicTypePicture:
            self.pictureView.frame = self.topic.middleFrame;
            break;
        case NJTopicTypeVideo:
            self.videoView.frame = self.topic.middleFrame;
            break;
        case NJTopicTypeVoice:
            self.voiceView.frame = self.topic.middleFrame;
            break;
        default:
            break;
    }
}
- (void)setTopic:(NJTopic *)topic
{
    _topic = topic;
    //设置头像
    [self.profileImageV setHeaderImage:topic.profile_image];
    //设置用户名
    self.nameLabel.text = topic.name;
    //设置时间
    self.passtimeLabel.text = topic.passtime;
    //设置帖子内容
    self.myTextLabel.text = topic.text;
    //设置最热评论
    if(topic.top_cmt.count != 0)
    {
        self.topCommentView.hidden = NO;
        NSDictionary * topComment = [topic.top_cmt firstObject];
        //设置评论内容
        NSString * userName = topComment[@"user"][@"username"];
        NSString * commentContent = topComment[@"content"];
        if(commentContent.length == 0)//语音评论
        {
            commentContent = @"[语音评论]";
        }
        NSString * comment = [NSString stringWithFormat:@"%@ : %@",userName,commentContent];
        self.commentContentLabel.text = comment;

    }
    else
    {
        self.topCommentView.hidden = YES;
    }
    
    //设置顶按钮
    [self setupButtonWithNumber:topic.ding button:self.dingBtn placeholder:@"顶"];
    //设置踩按钮
    [self setupButtonWithNumber:topic.cai button:self.caiBtn placeholder:@"踩"];
    //设置转发按钮
    [self setupButtonWithNumber:topic.repost button:self.repostBtn placeholder:@"分享"];
    //设置评论按钮
    [self setupButtonWithNumber:topic.comment button:self.commentBtn placeholder:@"评论"];
    
    /*
     xib: contentView{308,307},voiceView{122,90}
     实际: contentView{414,120},voiceView{228,0}
     */
    //加载中间控件
    switch (topic.type) {
        case NJTopicTypePicture://图片
        {
            self.pictureView.hidden = NO;
            self.videoView.hidden = YES;
            self.voiceView.hidden = YES;
            self.pictureView.topic = topic;//设置数据模型
        }
            break;
        case NJTopicTypeVideo://视频
        {
            self.pictureView.hidden = YES;
            self.videoView.hidden = NO;
            self.voiceView.hidden = YES;
            self.videoView.topic = topic;//设置数据模型
        }
            break;
        case NJTopicTypeVoice://声音
        {
            self.pictureView.hidden = YES;
            self.videoView.hidden = YES;
            self.voiceView.hidden = NO;
            self.voiceView.topic = topic;//设置数据模型
        }
            break;
        case NJTopicTypeWord://文字
            self.pictureView.hidden = YES;
            self.videoView.hidden = YES;
            self.voiceView.hidden = YES;
            break;
        default:
            break;
    }
}

/**
 设置底部按钮标题

 @param number 数量
 @param button 那个按钮
 @param placeholder 数量为0时的文字
 */
- (void)setupButtonWithNumber:(NSInteger) number button:(UIButton *)button placeholder:(NSString *)placeholder
{
    if(number>= 10000)
    {
        NSString * dingStr = [NSString stringWithFormat:@"%.1f万",number/ 10000.0];
        [button setTitle:[dingStr stringByReplacingOccurrencesOfString:@".0" withString:@""] forState:UIControlStateNormal];
        
    }else if(number > 0)
    {
        [button setTitle:[NSString stringWithFormat:@"%ld",number] forState:UIControlStateNormal];
    }else
    {
        [button setTitle:placeholder forState:UIControlStateNormal];
    }

}
//设置cell间距
- (void)setFrame:(CGRect)frame
{
    frame.size.height -= NJCellMargin;
    [super setFrame:frame];
    
}
@end
