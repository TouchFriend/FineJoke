//
//  NJComment.h
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/7/15.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NJUser;
@interface NJComment : NSObject
/** id */
@property (nonatomic, copy) NSString *ID;

/** 文字内容 */
@property (nonatomic, copy) NSString *content;

/** 用户 */
@property (nonatomic, strong) NJUser *user;

/** 点赞数 */
@property (nonatomic, assign) NSInteger like_count;

/** 语音文件的路径 */
@property (nonatomic, copy) NSString *voiceuri;

/** 语音文件的时长 */
@property (nonatomic, assign) NSInteger voicetime;
@end
