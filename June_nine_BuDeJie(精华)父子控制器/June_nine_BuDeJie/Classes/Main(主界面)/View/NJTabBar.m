//
//  NJTabBar.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/12.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJTabBar.h"
#import "NJPublicVC.h"

@interface NJTabBar ()
/********* 添加按钮 *********/
@property(nonatomic,weak)UIButton * plusBtn;
/********* 上一个被点击的TabBarButton *********/
@property(nonatomic,weak)UIControl * previousClickedTabBarBtn;
@end
@implementation NJTabBar

//懒加载
-(UIButton *)plusBtn
{
    if(_plusBtn == nil)
    {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        //添加事件
        [btn addTarget:self action:@selector(plusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //设置size
        [btn sizeToFit];
        //添加到父控件中
        [self addSubview:btn];
        _plusBtn = btn;
    }
    return _plusBtn;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    //总共的子控件
    NSUInteger count = self.items.count;
    CGFloat btnW = self.NJ_width / (count + 1);
    CGFloat btnH = self.NJ_height;
    CGFloat btnY = 0;
    int i = 0;
    for (UIControl * tabBarBtn in self.subviews) {
        //重新布局 （UITabBarButton的父类是UIControl）
        if([tabBarBtn isKindOfClass:NSClassFromString(@"UITabBarButton")])
        {
            //如果i=0和前一个被点击的按钮为空，将第0个按钮给它赋值
            if(i == 0 && self.previousClickedTabBarBtn == nil)
            {
                self.previousClickedTabBarBtn = tabBarBtn;
            }
            //留出空位
            if(i == (count / 2))
            {
                i++;
            }
            CGFloat btnX = i * btnW;
            tabBarBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            i++;
            [tabBarBtn addTarget:self action:@selector(tabBarBtnClick:) forControlEvents:UIControlEventTouchUpInside
             ];
            
        }
    }
    //设置plus按钮位置
    self.plusBtn.center = CGPointMake(self.NJ_width * 0.5, self.NJ_height * 0.5);
}
#pragma mark - 点击tabBarBtn
- (void)tabBarBtnClick:(UIControl *)tabBarBtn
{
    if(self.previousClickedTabBarBtn == tabBarBtn)
    {
        //发布通知
        [[NSNotificationCenter defaultCenter] postNotificationName:NJTabBarButtonDidRepeatClickNotification object:nil];
    }
    self.previousClickedTabBarBtn = tabBarBtn;
}
#pragma mark - 点击发布按钮
- (void)plusBtnClick:(UIButton *)button
{
    //跳转到发布界面
    NJPublicVC * publicVC = [[NJPublicVC alloc]init];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:publicVC animated:YES completion:nil];
}
@end
