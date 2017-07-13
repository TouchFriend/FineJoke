//
//  NJSquareCell.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/15.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJSquareCell.h"
#import "NJSquareItem.h"
#import <UIImageView+WebCache.h>
@interface NJSquareCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation NJSquareCell

- (void)setSquareItem:(NJSquareItem *)squareItem
{
    _squareItem = squareItem;
    //设置控件数据
    //1.设置图片
    NSURL * iconUrl = [NSURL URLWithString:squareItem.icon];
    [self.iconImageView sd_setImageWithURL:iconUrl];
    //2.设置文字
    self.nameLabel.text = squareItem.name;
}
@end
