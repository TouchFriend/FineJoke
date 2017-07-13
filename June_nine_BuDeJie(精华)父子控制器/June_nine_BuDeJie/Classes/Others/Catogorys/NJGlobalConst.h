//
//  NJGlobalConst.h
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/19.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import <UIKit/UIKit.h>
//UIKIT_EXTERN简单来说，就是将函数修饰为兼容以往C编译方式的、具有extern属性(文件外可见性)、public修饰的方法或变量库外仍可见的属性
//tabBar的高度
UIKIT_EXTERN CGFloat const NJTabBarHeight;
//导航条的最大y
UIKIT_EXTERN CGFloat const NJNavBarMaxY;
//标题栏的高度
UIKIT_EXTERN CGFloat const NJTitleBarHeight;
//TabBarButton被重复点击的通知
UIKIT_EXTERN NSString * const NJTabBarButtonDidRepeatClickNotification;
//标题栏按钮被点击的通知
UIKIT_EXTERN NSString * const NJTitleBarButtonDidRepeatClickNotification;
//footerView未刷新时的文字
UIKIT_EXTERN NSString * const NJNotRefreshText;
//footerView正在刷新时的文字
UIKIT_EXTERN NSString * const NJisRefreshingText;
