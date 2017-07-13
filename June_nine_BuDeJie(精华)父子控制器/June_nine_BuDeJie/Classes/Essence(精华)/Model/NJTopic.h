//
//  NJTopic.h
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/21.
//  Copyright © 2017年 cxz. All rights reserved.
//
typedef NS_ENUM(NSInteger,NJTopicType)
{
    NJTopicTypePicture = 10,//图片
    NJTopicTypeWord = 29,//段子
    NJTopicTypeVoice = 31,//音频
    NJTopicTypeVideo = 41,//视频
};
#import <Foundation/Foundation.h>
@interface NJTopic : NSObject
/********* 头像URL *********/
@property(nonatomic,strong)NSString * profile_image;
/********* 用户名 *********/
@property(nonatomic,strong)NSString * name;
/********* 审核通过时间 *********/
@property(nonatomic,strong)NSString * passtime;
/********* 内容 *********/
@property(nonatomic,strong)NSString * text;

/********* 点赞人数 *********/
@property(nonatomic,assign)NSInteger ding;
/********* 踩的人数 *********/
@property(nonatomic,assign)NSInteger cai;
/********* 转发人数 *********/
@property(nonatomic,assign)NSInteger repost;
/********* 评论人数 *********/
@property(nonatomic,assign)NSInteger comment;

/********* 热门评论 *********/
@property(nonatomic,strong)NSArray * top_cmt;

/** 帖子的类型 10为图片 29为段子 31为音频 41为视频 */
@property(nonatomic,assign)NSInteger type;


/********* cell高度 *********/
@property(nonatomic,assign)CGFloat cellHeight;

/********* 图片/音频/视频的宽度 *********/
@property(nonatomic,assign)CGFloat width;
/********* 图片/音频/视频的高度 *********/
@property(nonatomic,assign)CGFloat height;
/********* 图片/音频/视频的frame *********/
@property(nonatomic,assign)CGRect middleFrame;

/********* 视频/音频 播放量 *********/
@property(nonatomic,assign)NSInteger playcount;
/********* 播放地址 *********/
@property(nonatomic,strong)NSString * videouri;
/********* 视频时长 *********/
@property(nonatomic,assign)NSInteger videotime;

/********* 声音时长 *********/
@property(nonatomic,assign)NSInteger voicetime;
/********* 音频地址 *********/
@property(nonatomic,strong)NSString * voiceuri;

/********* 小图 *********/
@property(nonatomic,strong)NSString * image0;
/********* 中图 *********/
@property(nonatomic,strong)NSString * image2;
/********* 大图(原图) *********/
@property(nonatomic,strong)NSString * image1;



@end
