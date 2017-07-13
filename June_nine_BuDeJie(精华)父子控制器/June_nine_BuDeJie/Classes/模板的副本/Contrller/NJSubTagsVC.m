//
//  NJSubTagsVC.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/13.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJSubTagsVC.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "NJSubTagItem.h"
#import "NJSubTagCell.h"
#import <SVProgressHUD.h>
#import <MJRefresh/MJRefresh.h>
#import "NJChibaoGifHeader.h"

#define NJSubTagUrl @"http://api.budejie.com/api/api_open.php"
@interface NJSubTagsVC ()
/********* 模型数组 *********/
@property(nonatomic,strong)NSArray * subTagArr;
/********* AFN管理者 *********/
@property(nonatomic,weak)AFHTTPSessionManager * manager;
@end

@implementation NJSubTagsVC
NSString * const ID = @"SubTag";
- (void)viewDidLoad {
    [super viewDidLoad];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"NJSubTagCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ID];
    // 处理cell分割线 1.自定义分割线 2.系统属性(iOS8才支持) 3.万能方式(重写cell的setFrame) 了解tableView底层实现了解 1.取消系统自带分割线 2.把tableView背景色设置为分割线的背景色 3.重写setFrame

    //self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 220 220 221
    self.tableView.backgroundColor = NJColor(220, 220, 221);
    //设置刷新
    [self setupDownDragRefresh];
}
#pragma mark - 设置下拉刷新
- (void)setupDownDragRefresh
{
    //下拉刷新控件
    self.tableView.mj_header = [NJChibaoGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    //根据拖拽比例自动切换透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    //一进入view就自动刷新
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //取消指示器
    [SVProgressHUD dismiss];
    //取消之前的请求
    [_manager.tasks makeObjectsPerformSelector:@selector(cancel)];
}
#pragma mark - 懒加载
- (void)loadData
{

    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    _manager = manager;
    //拼接参数
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"tag_recommend";
    parameters[@"action"] = @"sub";
    parameters[@"c"] = @"topic";
    //发送请求
    [manager GET:NJSubTagUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable responseObject) {
        //数据转模型
        _subTagArr = [NJSubTagItem mj_objectArrayWithKeyValuesArray:responseObject];
        //刷新表格
        [self.tableView reloadData];
        //结束刷新
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subTagArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NJSubTagCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //取出对应的模型
    NJSubTagItem * item = self.subTagArr[indexPath.row];
    //设置数据
    cell.item = item;
    
    return cell;
}
#pragma mark - UITableViewDelegate方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
@end
