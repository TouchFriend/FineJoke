//
//  NJADItem.h
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/13.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NJADItem : NSObject
//(w_picurl,ori_curl:跳转到广告界面,w,h)
/********* 广告地址 *********/
@property(nonatomic,strong)NSString * ori_curl;
/********* 广告图片地址 *********/
@property(nonatomic,strong)NSString * w_picurl;
/********* 广告图片宽度 *********/
@property(nonatomic,assign)CGFloat w;
/********* 广告图片高度 *********/
@property(nonatomic,assign)CGFloat h;



@end
