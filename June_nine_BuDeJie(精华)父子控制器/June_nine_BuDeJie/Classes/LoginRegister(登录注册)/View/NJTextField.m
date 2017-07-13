//
//  NJTextField.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/14.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJTextField.h"
#import "UITextField+NJPlaceHolder.h"
@implementation NJTextField
- (void)awakeFromNib
{
    [super awakeFromNib];
    //1.设置光标成白色
    self.tintColor = [UIColor whiteColor];
    //2.设置占位文字成白色
    //2.1开始编辑时，变成白色
    [self addTarget:self action:@selector(beginEdite) forControlEvents:UIControlEventEditingDidBegin];
    //2.2结束编辑时，变成灰色
    [self addTarget:self action:@selector(endEdite) forControlEvents:UIControlEventEditingDidEnd];
    //3.预先设置占位文字成灰色
    //_placeholderLabel	id	0x0
    //placeHolder的类型是UILabel
    self.placeHolderColor = [UIColor grayColor];
}

- (void)beginEdite
{
    self.placeHolderColor = [UIColor whiteColor
                             ];
}
- (void)endEdite
{
    self.placeHolderColor = [UIColor grayColor];
}
@end
