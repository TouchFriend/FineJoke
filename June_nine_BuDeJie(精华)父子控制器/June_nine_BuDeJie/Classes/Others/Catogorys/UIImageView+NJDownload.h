//
//  UIImageView+NJDownload.h
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/28.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>
@interface UIImageView (NJDownload)
- (void)setOriginImageWithURL:(NSString *)originImageURL setThumbnailImageWithURL:(NSString *)thumbnailImageURL placeholder:(UIImage *)placeholder complete:( SDWebImageCompletionBlock)completeBlock;
- (void)setHeaderImage:(NSString *)headerImageURL;
@end
