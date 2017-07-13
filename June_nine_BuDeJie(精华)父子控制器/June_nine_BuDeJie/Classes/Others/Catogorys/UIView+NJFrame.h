//
//  UIView+NJFrame.h
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/12.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NJFrame)
/********* x坐标 *********/
@property(nonatomic,assign)CGFloat NJ_x;
/********* y坐标 *********/
@property(nonatomic,assign)CGFloat NJ_y;
/********* width坐标 *********/
@property(nonatomic,assign)CGFloat NJ_width;
/********* height坐标 *********/
@property(nonatomic,assign)CGFloat NJ_height;
/********* 中心x坐标 *********/
@property(nonatomic,assign)CGFloat NJ_centerX;
/********* 中心y坐标 *********/
@property(nonatomic,assign)CGFloat NJ_centerY;

@end
