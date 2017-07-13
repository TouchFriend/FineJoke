//
//  NJSubTagItem.h
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/13.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NJSubTagItem : NSObject
/*
 image_list/theme_name/sub_number
 */
/********* 标签图片地址 *********/
@property(nonatomic,strong)NSString * image_list;
/********* 标签名 *********/
@property(nonatomic,strong)NSString * theme_name;
/********* 订阅数 *********/
@property(nonatomic,strong)NSString * sub_number;



@end
