//
//  NJFastLoginButton.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/14.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJFastLoginButton.h"

@implementation NJFastLoginButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    //1.设置图片位置
    self.imageView.NJ_y = 0;
    self.imageView.NJ_centerX = self.NJ_width * 0.5;
    //2.设置title位置
    self.titleLabel.NJ_y = self.NJ_height - self.titleLabel.NJ_height;
    // 计算文字宽度 , 设置label的宽度
    [self.titleLabel sizeToFit];
    self.titleLabel.NJ_centerX = self.NJ_width * 0.5;

}

@end
