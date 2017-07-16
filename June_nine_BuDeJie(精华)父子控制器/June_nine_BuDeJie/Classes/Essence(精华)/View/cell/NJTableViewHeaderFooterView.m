//
//  NJTableViewHeaderFooterView.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/7/15.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJTableViewHeaderFooterView.h"
@interface NJTableViewHeaderFooterView ()
/********* 每组标题 *********/
@property(nonatomic,weak)UILabel * sectionTitleLabel;
@end
@implementation NJTableViewHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        //添加子控件
        UILabel * sectionTitleLabel = [[UILabel alloc]init];
        [self.contentView addSubview:sectionTitleLabel];
        //文字颜色
        sectionTitleLabel.textColor = NJGrayColor(122);
        //字体大小
        sectionTitleLabel.font = [UIFont systemFontOfSize:14.0];
        self.sectionTitleLabel = sectionTitleLabel;
    }
    return self;
}
//布局子控件
- (void)layoutSubviews
{
    self.sectionTitleLabel.frame = CGRectMake(NJCellSmallMargin, self.NJ_height - 20, NJScreenW, 20);
}
- (void)setTitle:(NSString *)title
{
    _title = title;
    //设置每组标题
    self.sectionTitleLabel.text = title;
}
@end
