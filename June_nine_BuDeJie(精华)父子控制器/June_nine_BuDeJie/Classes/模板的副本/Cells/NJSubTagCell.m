//
//  NJSubTagCell.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/13.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJSubTagCell.h"
#import "NJSubTagItem.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface NJSubTagCell ()
@property (weak, nonatomic) IBOutlet UIImageView *subTagImageV;
@property (weak, nonatomic) IBOutlet UILabel *tagNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNumberLabel;
- (IBAction)subBtnClick:(UIButton *)sender;

@end
@implementation NJSubTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //设置图片成圆形
    self.subTagImageV.layer.cornerRadius = self.subTagImageV.frame.size.width / 2.0;
    self.subTagImageV.layer.masksToBounds = YES;
}
- (void)setFrame:(CGRect)frame
{
//    NSLog(@"%@",NSStringFromCGRect(frame));
    //将高度减一，露出背景
    frame.size.height -= 1;
    [super setFrame:frame];
}
- (void)setItem:(NJSubTagItem *)item
{
    _item = item;
    //1.设置图片
    NSURL * imageUrl = [NSURL URLWithString:item.image_list];
    [self.subTagImageV sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    //2.设置标签名称
    self.tagNameLabel.text = item.theme_name;
    //3.设置订阅数
    [self setupSubNumber];

}
#pragma mark - 设置订阅数
- (void)setupSubNumber
{
    //判断是否超过一万
    NSInteger subNumber = _item.sub_number.integerValue;
    NSString * subNumberStr = [NSString stringWithFormat:@"%@人订阅",_item.sub_number];
    if( subNumber > 10000)
    {
        CGFloat subNumberWan = subNumber / 10000.0;
        subNumberStr = [NSString stringWithFormat:@"%.1f人订阅",subNumberWan];
        
        [subNumberStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    }
    self.subNumberLabel.text = subNumberStr;
}
- (IBAction)subBtnClick:(UIButton *)sender {
}
@end
