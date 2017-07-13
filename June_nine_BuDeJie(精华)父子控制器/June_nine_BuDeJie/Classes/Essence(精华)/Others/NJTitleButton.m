//
//  NJTitleButton.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/18.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJTitleButton.h"

@implementation NJTitleButton
/*
 特定构造方法
 1> 后面带有NS_DESIGNATED_INITIALIZER的方法，就是特定构造方法
 
 2> 子类如果重写了父类的【特定构造方法】，那么必须用super调用父类的【特定构造方法】，不然会出现警告
 */

/*
 警告信息:Designated initializer missing a 'super' call to a designated initializer of the super class
 意思：【特定构造方法】缺少super去调用父类的【特定构造方法】
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame: frame])
    {
        //设置normarl状态颜色
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        //设置文字大小
        [self.titleLabel setFont:[UIFont systemFontOfSize:15]];
        //设置选中状态标题颜色
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    }
    return self;
}
//重写方法，使按钮不能进入高亮状态
- (void)setHighlighted:(BOOL)highlighted
{
    
}

@end
