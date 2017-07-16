//
//  NJCommentCell.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/7/14.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJCommentCell.h"
#import "NJComment.h"
@implementation NJCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setComment:(NJComment *)comment
{
    _comment = comment;
}

@end
