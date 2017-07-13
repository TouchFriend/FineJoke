//
//  NJFileTool.h
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/16.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NJFileTool : NSObject

/**
 移除文件夹的所有内容

 @param directoryPath 文件夹路径
 */
+ (void)removeDirectoryPath:(NSString *)directoryPath;
/**
 计算文件夹大小

 @param directoryPath 文件夹路径
 @param completion 完成时回调block，返回文件夹大小
 */
+ (void)getFileSize:(NSString *)directoryPath completion:(void(^)(NSInteger fileSize)) completion;
@end
