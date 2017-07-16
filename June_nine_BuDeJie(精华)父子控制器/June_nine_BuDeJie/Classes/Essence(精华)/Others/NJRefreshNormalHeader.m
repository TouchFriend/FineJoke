//
//  NJRefreshNormalHeader.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/7/13.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJRefreshNormalHeader.h"

@implementation NJRefreshNormalHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        //隐藏上一次刷新时间
        self.lastUpdatedTimeLabel.hidden = YES;
        //改变状态颜色字体
        self.stateLabel.font = [UIFont systemFontOfSize:16.0];
        [self.stateLabel setTextColor:[UIColor redColor]];
        [self setTitle:@"下拉刷新哦" forState:MJRefreshStateIdle];
        [self setTitle:@"松开立即刷新哦" forState:MJRefreshStatePulling];
        [self setTitle:@"正在刷新哦" forState:MJRefreshStateRefreshing];
        //根据拖拽比例自动切换透明度
        self.automaticallyChangeAlpha = YES;
    }
    return  self;
}

@end
