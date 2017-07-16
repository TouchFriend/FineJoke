//
//  NJDIYRefreshHeader.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/7/13.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJDIYRefreshHeader.h"
@interface NJDIYRefreshHeader ()
/********* 开关 *********/
@property(nonatomic,weak)UISwitch * switchs;
/********* logo *********/
@property(nonatomic,weak)UIImageView * logo;
@end
@implementation NJDIYRefreshHeader
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        //添加开关
        UISwitch * switchs = [[UISwitch alloc]init];
        [self addSubview:switchs];
        self.switchs = switchs;
        //设置刷新控件的高度
        self.NJ_height = 50;
        //添加公司logo
        UIImageView * logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"side"]];
        [self addSubview:logo];
        self.logo = logo;
    }
    return self;
}
#pragma mark - 布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.switchs.NJ_centerX = self.NJ_width / 2.0;
    self.switchs.NJ_centerY = self.NJ_height / 2.0;
    
    self.logo.NJ_height = 100;
    self.logo.NJ_width = 100;
    self.logo.NJ_centerX = self.NJ_width / 2.0;
    self.logo.NJ_y = - 1.5 * self.logo.NJ_height;
}
#pragma mark - 重写head内部的方法
- (void)setState:(MJRefreshState)state
{
    [super setState:state];
    if(state == MJRefreshStateIdle)//普通闲置状态
    {
        [self.switchs setOn:NO animated:YES];
        [UIView animateWithDuration:0.25 animations:^{
            //恢复
            self.switchs.transform = CGAffineTransformIdentity;
        }];
        
    }
    else if(state == MJRefreshStatePulling)//松开就可以进行刷新的状态
    {
        [self.switchs setOn:YES animated:YES];
        [UIView animateWithDuration:0.25 animations:^{
            self.switchs.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];
    }
    else if(state == MJRefreshStateRefreshing)//正在刷新中的状态
    {
        [self.switchs setOn:YES animated:YES];
        [UIView animateWithDuration:0.25 animations:^{
            self.switchs.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];
    }
}
@end
