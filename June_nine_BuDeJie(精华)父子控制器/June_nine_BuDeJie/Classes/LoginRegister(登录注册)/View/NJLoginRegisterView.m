//
//  NJLoginRegisterView.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/14.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJLoginRegisterView.h"
@interface NJLoginRegisterView ()

@end

@implementation NJLoginRegisterView
+ (instancetype)loginView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}
+ (instancetype)registerView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}
@end
