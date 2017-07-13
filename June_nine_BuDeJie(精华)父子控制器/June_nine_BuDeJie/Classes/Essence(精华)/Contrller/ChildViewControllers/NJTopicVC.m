//
//  NJTopicVC.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/19.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJTopicVC.h"
#import <AFNetworking.h>
#import "NJTopic.h"
#import <MJExtension/MJExtension.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "NJTopicCell.h"
#import <SDImageCache.h>
#import <MJRefresh/MJRefresh.h>

#define NJMargin 10
@interface NJTopicVC ()
/********* maxtime(当前最后一条帖子的描述信息) *********/
@property(nonatomic,strong)NSString * maxtime;

/********* 广告 *********/
@property(nonatomic,weak)UIView * adView;
/********* 会话管理者 *********/
@property(nonatomic,strong)AFHTTPSessionManager * manager;


/********* 帖子(数据) *********/
@property(nonatomic,strong)NSMutableArray * topicsArrM;

@end

@implementation NJTopicVC
static NSString * const ID = @"NJTopicCellID";
- (void)viewDidLoad {
    [super viewDidLoad];
    //请求数据
    self.tableView.contentInset = UIEdgeInsetsMake(NJNavBarMaxY + NJTitleBarHeight, 0, NJTabBarHeight, 0);
    //监听TabBarButton被重复点击的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidRepeatClick) name:NJTabBarButtonDidRepeatClickNotification object:nil];
    //监听标题栏按钮的点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleBarButtonDidRepeatClick) name:NJTitleBarButtonDidRepeatClickNotification object:nil];
    //设置刷新
    [self setupRefresh];
    //设置滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NJTopicCell class]) bundle:nil] forCellReuseIdentifier:ID];
    //设置tableView的背景色
    self.tableView.backgroundColor = NJColor(215, 215, 215);
    //隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
}
- (NJTopicType)type
{
    return NJTopicTypeAll;
}
#pragma mark - 懒加载
- (AFHTTPSessionManager *)manager
{
    if(_manager == nil)
    {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}
#pragma mark - 请求下拉加载的数据
/*
 服务器数据：45，44，43，42，41，40，39，38，37，36，35，34，。。。。。。5，4，3，2，1
 
 下⬇️拉刷新（new-最新）@[45，44，43]
 
 上⬆️拉刷新（more-更多）@[37，36，35]
 
 客户端数据：
 self.topics = @[40，39，38]
 
 请求的回来先后顺序
 1.上⬆️拉刷新（more-更多）-> 下⬇️拉刷新（new-最新）
 self.topics = @[45，44，43]
 
 2.下⬇️拉刷新（new-最新）-> 上⬆️拉刷新（more-更多）
 self.topics = @[45，44，43，37，36，35]
 */
- (void)loadNewTopics
{
    /*
     Invalidates the managed session, optionally canceling pending tasks
     如果用invalidateSessionCancelingTasks:方法，不仅取消任务，还会使这个管理者的session失效，再也不能发送请求。
     [self.manager invalidateSessionCancelingTasks:YES];
     */
    //取消前一次的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @([self type]);//设置数据类型
    //发送请求
    [self.manager GET:NJCommonURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task,  NSDictionary *  _Nullable responseObject) {
        //存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        //数据转模型
        self.topicsArrM = [NJTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        //        NJDataWriteToPlist(@"ttt");
        //刷新表格
        [self.tableView reloadData];
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NJLog(@"%@",error);
        //不是取消请求的错误，而是其他原因导致的错误 NSURLErrorDomain
        //NSURLErrorCancelled = -999,
        if(error.code != NSURLErrorCancelled)
        {
            [SVProgressHUD showErrorWithStatus:@"网络繁忙,请稍后再试！"];
        }
        //结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
}
/*
 Error Domain=NSURLErrorDomain Code=-999 "cancelled" UserInfo={NSErrorFailingURLKey=http://api.budejie.com/api/api_open.php?a=list&c=data&type=31, NSLocalizedDescription=cancelled, NSErrorFailingURLStringKey=http://api.budejie.com/api/api_open.php?a=list&c=data&type=31}
 */
#pragma mark - 请求上拉加载的更多新数据
- (void)loadMoreTopics
{
    //取消前一次的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @([self type]);//设置数据类型
    parameters[@"maxtime"] = self.maxtime;
    //发送请求
    [self.manager GET:NJCommonURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task,  NSDictionary *  _Nullable responseObject) {
        //存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        //数据转模型
        NSArray * moreTopics = [NJTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        //追加旧模型数组中
        [self.topicsArrM addObjectsFromArray:moreTopics];
        //刷新表格
        [self.tableView reloadData];
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
//        if(self.topicsArrM.count >= 40)
//        {
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        }
//        else
//        {
//            [self.tableView.mj_footer endRefreshing];
//        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NJLog(@"%@",error);
        if(error.code != -999)
        {
            [SVProgressHUD showErrorWithStatus:@"网络繁忙,请稍后再试！"];
        }
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - 设置刷新
- (void)setupRefresh
{
    //设置上拉刷新
    [self setupUpDragRefresh];
    //设置下拉刷新
    [self setupDownDragRefresh];
}
#pragma mark - 设置下拉刷新
- (void)setupDownDragRefresh
{
    //广告
    UIView * adView = [[UIView alloc]init];
    adView.frame = CGRectMake(0, 0, self.tableView.NJ_width, 44);
    adView.backgroundColor = [UIColor greenColor];
    self.adView = adView;
    self.tableView.tableHeaderView = adView;
    //下拉刷新控件
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    //根据拖拽比例自动切换透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    //一进入view就自动刷新
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - 设置上拉刷新
- (void)setupUpDragRefresh
{
    //上拉刷新控件
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}
#pragma mark - 标题栏按钮被点击
- (void)titleBarButtonDidRepeatClick
{
    [self tabBarButtonDidRepeatClick];
}
#pragma mark - 精华TabBarButton被重复点击
- (void)tabBarButtonDidRepeatClick
{
    //1.判断是否是精华被重复点击(tabBarController是暂时隐藏上一个控制器，显示被点击的tabBarButton对应的子控制器，所以可以通过window是否有值来判断)
    if(!self.view.window)
    {
        return;
    }
    //2.判断全部子控制器的view在正中间(只有正中间view的scrollsToTop是YES)
    if(!self.tableView.scrollsToTop)
    {
        return;
    }
    //下拉刷新数据
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //判断数据量是否为0，为0隐藏footerView
    self.tableView.mj_footer.hidden = (self.topicsArrM.count == 0);
    return self.topicsArrM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NJTopicCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //取出对应的模型
    NJTopic * topic = self.topicsArrM[indexPath.row];
    //设置对应的数据
    cell.topic = topic;
    //NJLog(@"%ld,%p",indexPath.row,cell);
    return cell;
}
#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NJLog(@"%ld--%s",indexPath.row,__func__);
    //取出对应的数据模型
    NJTopic * topic = self.topicsArrM[indexPath.row];
    return topic.cellHeight;
}
#pragma mark - dealloc
- (void)dealloc
{
    //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - TableViewDelegate方法
//滚动过程中调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //清除内存缓存
    [[SDImageCache sharedImageCache] clearMemory];
}

@end
