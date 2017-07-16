//
//  NJPublicButton.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/7/17.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJPublicButton.h"

@implementation NJPublicButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.NJ_y = 0;
    self.imageView.NJ_centerX = self.NJ_width * 0.5;
    
    self.titleLabel.NJ_width = self.NJ_width;
    self.titleLabel.NJ_y = CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.NJ_x = 0;
    self.titleLabel.NJ_height = self.NJ_height - self.titleLabel.NJ_y;
}


@end
