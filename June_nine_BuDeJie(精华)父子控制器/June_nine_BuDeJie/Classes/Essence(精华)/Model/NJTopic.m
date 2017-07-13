//
//  NJTopic.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/21.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJTopic.h"

@implementation NJTopic
- (CGFloat)cellHeight
{
    if(_cellHeight > 0)
    {
        return _cellHeight;
    }
    //计算cell高度
    CGFloat cellHeight = 0;
    //1.加顶部条高度
    cellHeight += 60;
    //2.加文字内容高度
    CGSize textMaxSize = CGSizeMake(NJScreenW - 2 * NJCellMargin, CGFLOAT_MAX);//文字内容的最大宽度高度
    CGFloat textHeight = [self.text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil].size.height;
    cellHeight += textHeight + NJCellMargin;
    //3.中间view的高度
    if(self.type != NJTopicTypeWord)//不是文字cell
    {
        CGFloat middleX = NJCellMargin;
        CGFloat middleY = cellHeight;
        CGFloat middleW = textMaxSize.width;//(中间内容的实际宽度)文字的最大宽度
        CGFloat middleH = middleW * self.height / self.width;;//等比例缩放
        _middleFrame = CGRectMake(middleX, middleY, middleW, middleH);
        cellHeight += middleH + NJCellMargin;//cell高度加上中间控件的高度
    }
    //4.加热门评论
    if(_top_cmt.count > 0)
    {
        //标题高度
        cellHeight += 20;
        //评论内容高度
        NSDictionary * topComment = [_top_cmt firstObject];
        NSString * userName = topComment[@"user"][@"username"];
        NSString * commentContent = topComment[@"content"];
        if(commentContent.length == 0)//语音评论
        {
            commentContent = @"[语音评论]";
        }
        NSString * comment = [NSString stringWithFormat:@"%@ : %@",userName,commentContent];
        CGSize commentMaxSize = CGSizeMake(NJScreenW - 2 * NJCellMargin, CGFLOAT_MAX);//文字内容的最大宽度高度
        cellHeight += [comment boundingRectWithSize:commentMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil].size.height + NJCellMargin;
    }
    //5.加底部条高度 + 间距 + cell的间隔
    cellHeight += 35 + NJCellMargin;
    return cellHeight;
}

@end
