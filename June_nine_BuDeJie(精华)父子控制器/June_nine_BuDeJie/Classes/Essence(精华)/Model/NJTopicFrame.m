//
//  NJTopicFrame.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/24.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJTopicFrame.h"
#import "NJTopic.h"
@implementation NJTopicFrame
- (void)setTopic:(NJTopic *)topic
{
    _topic = topic;
    //计算cell高度
    CGFloat cellHeight = 0;
    //1.加顶部条高度
    cellHeight += 60;
    //2.加文字内容高度
    CGSize textSize = CGSizeMake(NJScreenW - 2 * 10, CGFLOAT_MAX);//文字内容的最大宽度高度
    CGFloat textHeight = [topic.text boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : @16} context:nil].size.height;
    cellHeight += textHeight;
    //2.加底部条高度
    cellHeight += 35;
}
@end
