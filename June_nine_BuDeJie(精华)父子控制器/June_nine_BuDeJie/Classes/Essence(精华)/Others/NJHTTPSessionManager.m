//
//  NJHTTPSessionManager.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/7/13.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJHTTPSessionManager.h"

@implementation NJHTTPSessionManager
- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    if(self = [super initWithBaseURL:url sessionConfiguration:configuration])
    {
        //设置请求头
        [self.requestSerializer setValue:[UIDevice currentDevice].model forHTTPHeaderField:@"Phone"];
        [self.requestSerializer setValue:[UIDevice currentDevice].systemVersion forHTTPHeaderField:@"OS"];
    }
    return self;
}
@end
