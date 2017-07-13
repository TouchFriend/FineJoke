//
//  NJTopicFrame.h
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/24.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NJTopic;
@interface NJTopicFrame : NSObject
/********* 帖子数据 *********/
@property(nonatomic,strong)NJTopic * topic;
/********* 帖子高度 *********/
@property(nonatomic,assign)CGFloat cellHeight;

@end
