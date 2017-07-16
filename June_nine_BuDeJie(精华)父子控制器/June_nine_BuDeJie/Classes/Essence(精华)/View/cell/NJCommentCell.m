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

@end
@implementation NJCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
@end
