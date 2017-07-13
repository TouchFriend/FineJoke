//
//  NJFastLoginView.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/14.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJFastLoginView.h"

@implementation NJFastLoginView
+ (instancetype)fastLoginView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

@end
