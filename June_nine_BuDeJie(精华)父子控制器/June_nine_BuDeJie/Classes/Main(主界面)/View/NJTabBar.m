//
//  NJTabBar.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/12.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJTabBar.h"

@interface NJTabBar ()
/********* 添加按钮 *********/
@property(nonatomic,weak)UIButton * plusBtn;
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
    for (UIView * tabBarBtn in self.subviews) {
        //重新布局
        if([tabBarBtn isKindOfClass:NSClassFromString(@"UITabBarButton")])
        {
            //留出空位
            if(i == (count / 2))
            {
                i++;
            }
            CGFloat btnX = i * btnW;
            tabBarBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            i++;
        }
    }
    //设置plus按钮位置
    self.plusBtn.center = CGPointMake(self.NJ_width * 0.5, self.NJ_height * 0.5);
}

@end
