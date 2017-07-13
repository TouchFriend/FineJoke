//
//  NJFileTool.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/16.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJFileTool.h"

@implementation NJFileTool
+ (void)removeDirectoryPath:(NSString *)directoryPath
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    //判断文件夹是否存在或者是否是文件夹
    BOOL isDirectory = YES;
    BOOL isExist = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    if(!isDirectory || !isExist)
    {
       //报错
        NSException * exception =[NSException exceptionWithName:@"pathError" reason:@"路径不存在或者不是文件夹路径" userInfo:nil];
        [exception raise];
    }
    //获取一级子路径
    NSArray * subPathArr = [fileManager contentsOfDirectoryAtPath:directoryPath error:nil];
    for (NSString * subPath in subPathArr)
    {
        //拼接子路径
        NSString * fullPath = [directoryPath stringByAppendingPathComponent:subPath];
        //移除文件
        [fileManager removeItemAtPath:fullPath error:nil];
    }
}
+ (void)getFileSize:(NSString *)directoryPath completion:(void(^)(NSInteger fileSize)) completion
{
    //创建文件管理者
    NSFileManager * fileManager = [NSFileManager defaultManager];
    //判断文件夹是否存在或者是否是文件夹
    BOOL isDirectory = YES;
    BOOL isExist = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    if(!isDirectory || !isExist)
    {
        //报错
        NSException * exception =[NSException exceptionWithName:@"pathError" reason:@"路径不存在或者不是文件夹路径" userInfo:nil];
        [exception raise];
    }
    //在子线程中计算缓存大小
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //获取所有的子路径，包括子路径的子路径
        NSArray * subPaths = [fileManager subpathsAtPath:directoryPath];
        //计算文件大小
        NSInteger fileSize = 0;
        for (NSString * subPath in subPaths) {
            //1.拼接文件全路径
            NSString * fullSubPath = [directoryPath stringByAppendingPathComponent:subPath];
            //2.判断是否是隐藏文件
            if([subPath isEqualToString:@".DS_Store"])
            {
                continue;
            }
            //3.判断是否是文件夹
            BOOL isDirectory = NO;
            BOOL isFileExist = [fileManager fileExistsAtPath:fullSubPath isDirectory:&isDirectory];
            if(isDirectory || !isFileExist)
            {
                continue;
            }
            //获取文件属性
            NSDictionary * attDic = [fileManager attributesOfItemAtPath:fullSubPath error:nil];
            fileSize += [attDic fileSize];
            
        }
        //block回调(在主线程中回调)
        dispatch_sync(dispatch_get_main_queue(), ^{
            //判断block快是否存在
            if(completion)
            {
               completion(fileSize);
            }
            
        });
        
    });
    
}
@end
