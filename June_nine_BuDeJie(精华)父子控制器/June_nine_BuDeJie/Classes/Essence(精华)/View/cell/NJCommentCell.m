//
//  NJCommentCell.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/7/14.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJCommentCell.h"
#import "NJComment.h"
#import "NJUser.h"
#import <UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>

@interface NJCommentCell ()
/*********** 用户头像 ***********/
@property (weak, nonatomic) IBOutlet UIImageView *profileImageV;
/***********  性别 ***********/
@property (weak, nonatomic) IBOutlet UIImageView *sexImageV;
/*********** 用户名 ***********/
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
/*********** 评论内容 ***********/
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
/*********** 点赞数 ***********/
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
/*********** 声音播放按钮 ***********/
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
- (IBAction)voiceBtnClick:(UIButton *)sender;
/********* 音频播放 *********/
@property(nonatomic,strong)AVPlayer * voicePlayer;


@end
@implementation NJCommentCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voicePause) name:@"voicePause" object:nil];
}
//懒加载
- (AVPlayer *)voicePlayer
{
    if(_voicePlayer == nil)
    {
        AVPlayerItem * playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.comment.voiceuri]];
        _voicePlayer = [AVPlayer playerWithPlayerItem:playerItem];
    }
    return _voicePlayer;
}
- (void)setComment:(NJComment *)comment
{
//    NSLog(@"%@",[comment class]);
    _comment = comment;
    if(comment.voiceuri.length)
    {
        self.voiceBtn.hidden = NO;
        [self.voiceBtn setTitle:[NSString stringWithFormat:@"%ld",comment.voicetime] forState:UIControlStateNormal];
    }
    else
    {
        self.voiceBtn.hidden = YES;
    }
    //用户头像
    [self.profileImageV sd_setImageWithURL:[NSURL URLWithString:comment.user.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    //性别
    if([comment.user.sex isEqualToString:@"m"])
    {
        self.sexImageV.image = [UIImage imageNamed:@"Profile_manIcon"];
    }
    else
    {
        self.sexImageV.image = [UIImage imageNamed:@"Profile_womanIcon"];
    }
    //用户名
    self.usernameLabel.text = comment.user.username;
    //评论内容
    self.contentLabel.text = comment.content;
    //点赞数
    self.likeCountLabel.text = [NSString stringWithFormat:@"%ld",comment.like_count];
}
- (void)setFrame:(CGRect)frame
{
    //设置分割线
    frame.size.height -= 1;
    [super setFrame:frame];
    
}
#pragma mark - 点击声音播放按钮
- (IBAction)voiceBtnClick:(UIButton *)voiceButton
{
    BOOL selected = voiceButton.selected;
    //发布音乐停止通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"voicePause" object:nil];
    if(!selected)
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.voicePlayer play];
            
        });
    }
    voiceButton.selected = !selected;//改变按钮的状态

}
- (void)voicePause
{
    [self.voicePlayer pause];//停止播放音乐
    self.voiceBtn.selected = NO;//改变按钮状态
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"voicePause" object:nil];
}
@end
