//
//  NJComment.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/7/15.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJComment.h"
#import "NJUser.h"
@implementation NJComment
//计算cell的高度
- (CGFloat)cellHeight
{
    CGFloat cellHeight = 0;
    //1.加用户名高度
    cellHeight += NJCellMargin + 20 + NJCellMargin;
    //2.加文字内容高度
    //屏幕宽度 - 头像宽度 - 点赞宽度 - 间距
    CGSize textMaxSize = CGSizeMake(NJScreenW - 40 - 30 - 4 * NJCellMargin , CGFLOAT_MAX);//文字内容的最大宽度高度
    CGFloat textHeight = [self.content boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil].size.height;
    cellHeight += textHeight + NJCellMargin;
    
    return cellHeight;
}
@end
