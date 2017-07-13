//
//  UIImage+NJImage.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/10.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "UIImage+NJImage.h"

@implementation UIImage (NJImage)
//返回不被渲染的图片，更改图片的渲染模式
+(UIImage *)imageOriginNamed:(NSString *)imageName
{
    UIImage * image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  
}
@end
