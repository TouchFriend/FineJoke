//
//  NJSettingVC.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/12.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJSettingVC.h"
#import <SDImageCache.h>
#import "NJFileTool.h"
#import <SVProgressHUD.h>
#define NJCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
@interface NJSettingVC ()
/********* 模型数组 *********/
@property(nonatomic,strong)NSArray * dataArr;
/********* 缓存大小 *********/
@property(nonatomic,assign)NSInteger cacheSize;

@end

@implementation NJSettingVC
static NSString * const ID = @"testData";
- (void)viewDidLoad {
    [super viewDidLoad];
    //在命令行，可以用po cachePath （po + 变量名）打印变量的值
    [SVProgressHUD showWithStatus:@"正在计算缓存大小"];
    NSLog(@"%@",NJCachePath);
    //获取缓存大小
    [NJFileTool getFileSize:NJCachePath completion:^(NSInteger fileSize) {
        //保存缓存大小
        _cacheSize = fileSize;
        //刷新表格
        [self.tableView reloadData];
        //隐藏指示器
        [SVProgressHUD dismiss];
    }];
    //注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
}
#pragma mark - 获取缓存大小
- (NSString *)getCacheSizeStr
{
    NSString * cacheStr = @"清除缓存";
    NSInteger fileSize = _cacheSize;
    //MB KB B
    if(fileSize > 1000 * 1000)
    {
        //MB
        CGFloat sizeF = fileSize / 1000.0 / 1000.0;
        cacheStr = [NSString stringWithFormat:@"%@(%.1lfMB)",cacheStr,sizeF];
        
    }else if(fileSize > 1000)
    {
        //KB
        CGFloat sizeF = fileSize / 1000.0;
        cacheStr = [NSString stringWithFormat:@"%@(%.1lfKB)",cacheStr,sizeF];
    }else if(fileSize > 0)
    {
        //B
        cacheStr = [NSString stringWithFormat:@"%@(%ldB)",cacheStr,fileSize];
    }
    
    return cacheStr;
}
//懒加载
- (NSArray *)dataArr
{
    if(_dataArr == nil)
    {
        NSMutableArray * dataArrM = [NSMutableArray array];
        NSMutableArray * data1 = [NSMutableArray array];
        data1[0] = @"清除缓存";
        data1[1] = @"cxz";
        NSMutableArray * data2 = [NSMutableArray array];
        data2[0] = @"cxz";
        data2[1] = @"cxz";
        NSMutableArray * data3 = [NSMutableArray array];
        data3[0] = @"cxz";
        data3[1] = @"cxz";
        [dataArrM addObject:data1];
        [dataArrM addObject:data2];
        [dataArrM addObject:data3];
        _dataArr = dataArrM;
    }
    return _dataArr;
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray * data = self.dataArr[section];
    return data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //取出对应的模型
    NSArray * data = self.dataArr[indexPath.section];
    //设置数据
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        cell.textLabel.text = [self getCacheSizeStr];
    }else
    {
       cell.textLabel.text = data[indexPath.row];
    }
    
    
    return cell;
}
#pragma mark - UITableViewDelegate方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        //清除缓存
        [NJFileTool removeDirectoryPath:NJCachePath];
        //设置缓存数据为0
        self.cacheSize = 0;
        //刷新表格
        [self.tableView reloadData];
    }
}
@end
