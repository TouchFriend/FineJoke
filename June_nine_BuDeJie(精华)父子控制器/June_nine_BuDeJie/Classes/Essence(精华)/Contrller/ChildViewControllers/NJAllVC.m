//
//  NJAllVC.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/19.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJAllVC.h"
#import <AFNetworking.h>
#import "NJTopic.h"
#import <MJExtension/MJExtension.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface NJAllVC ()
/********* maxtime(当前最后一条帖子的描述信息) *********/
@property(nonatomic,strong)NSString * maxtime;

/********* headerView *********/
@property(nonatomic,weak)UIView * headerView;
/********* 广告 *********/
@property(nonatomic,weak)UIView * adView;
/********* footerLable *********/
@property(nonatomic,weak)UILabel * headerLabel;
/********* 是否处于下拉刷新状态 *********/
@property(nonatomic,assign,getter=isDownDragRefreshStatus)BOOL downDragRefreshStatus;

/********* footerView *********/
@property(nonatomic,weak)UIView * footerView;
/********* footerLable *********/
@property(nonatomic,weak)UILabel * footerLable;
/********* 是否处于上拉刷新状态 *********/
@property(nonatomic,assign,getter=isUpDragrefreshStatus)BOOL upDragrefreshStatus;
/********* 会话管理者 *********/
@property(nonatomic,strong)AFHTTPSessionManager * manager;


/********* 帖子(数据) *********/
@property(nonatomic,strong)NSMutableArray * topicsArrM;

@end

@implementation NJAllVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //请求数据
    self.tableView.backgroundColor = NJRandomColor;
    self.tableView.contentInset = UIEdgeInsetsMake(NJNavBarMaxY + NJTitleBarHeight, 0, NJTabBarHeight, 0);
    //监听TabBarButton被重复点击的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidRepeatClick) name:NJTabBarButtonDidRepeatClickNotification object:nil];
    //监听标题栏按钮的点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleBarButtonDidRepeatClick) name:NJTitleBarButtonDidRepeatClickNotification object:nil];
    //设置刷新
    [self setupRefresh];
    
    //设置滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
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
    parameters[@"type"] = @"31";//音频
    //发送请求
    [self.manager GET:NJCommonURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task,  NSDictionary *  _Nullable responseObject) {
        //存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        //数据转模型
        self.topicsArrM = [NJTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        //刷新表格
        [self.tableView reloadData];
        //结束刷新
        [self endDownDragRefreshing];
        NJLog(@"请求成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NJLog(@"%@",error);
        //不是取消请求的错误，而是其他原因导致的错误 NSURLErrorDomain
        //NSURLErrorCancelled = -999,
        if(error.code != NSURLErrorCancelled)
        {
           [SVProgressHUD showErrorWithStatus:@"网络繁忙,请稍后再试！"];
        }
        //结束刷新
        [self endDownDragRefreshing];
        
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
    parameters[@"type"] = @"31";//音频
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
        [self endUpDragRefreshing];
        NJLog(@"请求成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NJLog(@"%@",error);
        if(error.code != -999)
        {
            [SVProgressHUD showErrorWithStatus:@"网络繁忙,请稍后再试！"];
        }
        //结束刷新
        [self endUpDragRefreshing];
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
    UIView * headerView = [[UIView alloc]init];
    headerView.frame = CGRectMake(0, - adView.NJ_height, self.tableView.NJ_width, 44);
    headerView.backgroundColor = [UIColor grayColor];
    self.headerView = headerView;
    [self.tableView addSubview:headerView];

    UILabel * headerLabel = [[UILabel alloc]initWithFrame:headerView.bounds];
    headerLabel.text = NJDownDragNotRefreshingText;
    headerLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:headerLabel];
    self.headerLabel = headerLabel;
    
    //一进入view就自动刷新
    [self beginDownDragRefreshing];
}
#pragma mark - 设置上拉刷新
- (void)setupUpDragRefresh
{
    //上拉刷新控件
    UIView * footerView = [[UIView alloc]init];
    footerView.frame = CGRectMake(0, 0, self.tableView.NJ_width, 44);
    footerView.backgroundColor = [UIColor redColor];
    self.footerView = footerView;
    self.tableView.tableFooterView = footerView;
    
    UILabel * footerLable = [[UILabel alloc]initWithFrame:footerView.bounds];
    footerLable.text = NJUpDragNotRefreshText;
    footerLable.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:footerLable];
    self.footerLable = footerLable;
    

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
    [self beginDownDragRefreshing];
}
#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //判断数据量是否为0，为0隐藏footerView
    self.footerView.hidden = (self.topicsArrM.count == 0);
    return self.topicsArrM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
    }
    //取出对应的模型
    NJTopic * topic = self.topicsArrM[indexPath.row];
    cell.textLabel.text = topic.name;
    return cell;
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
    //下拉刷新
    [self resolveDownDragRefresh];
    //上拉刷新
    [self resolveUpDragRefresh];
}
//用户松开手后调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //判断松手时下拉刷新条是否完全显示
    CGFloat offsetY = NJNavBarMaxY + NJTitleBarHeight + self.headerView.NJ_height;
    if(self.tableView.contentOffset.y <= - offsetY)
    {
        //开始下拉刷新
        [self beginDownDragRefreshing];
    }
}
#pragma mark - 下拉刷新
- (void)resolveDownDragRefresh
{
    //如果处于下拉刷新状态，则返回
    if(self.isDownDragRefreshStatus)
    {
        return;
    }
    //下拉刷新条是否完全显示 (导航条最大y + 标题栏的高度 + 下拉控件的高度)
    CGFloat offsetY = NJNavBarMaxY + NJTitleBarHeight + self.headerView.NJ_height;
    if(self.tableView.contentOffset.y <= - offsetY)
    {
        self.headerLabel.text = NJDownDragCanRefreshingText;
    }
    else
    {
        self.headerLabel.text = NJDownDragNotRefreshingText;
    }
}
#pragma mark - 上拉刷新
- (void)resolveUpDragRefresh
{
    //// 还没有任何内容的时候，不需要判断（0.000000,49.000000,716.000000）
    if(self.tableView.contentSize.height == 0)
    {
        return;
    }
    //上拉刷新条是否完全显示 (内容高度 + 底部内边距 - 可视范围高度（frame高度）)
    CGFloat offsetY = self.tableView.contentSize.height + self.tableView.contentInset.bottom - self.tableView.NJ_height ;
    CGFloat contentOffsetY = self.tableView.contentOffset.y;
    if(contentOffsetY >= offsetY
       && contentOffsetY > - self.tableView.contentInset.top)//当上拉刷新条完全出现，而且是往上拉
    {
        //开始上拉刷新
        [self beginUpDragRefreshing];
    }
}
#pragma mark - 开始下拉刷新
- (void)beginDownDragRefreshing
{
    //如果处于下拉刷新状态，则返回
    if([self isDownDragRefreshStatus])
    {
        return;
    }
    self.headerLabel.text = NJisDownDragRefreshingText;
    //正在刷新中
    self.downDragRefreshStatus = YES;
    //增加内边距
    [UIView animateWithDuration:0.2 animations:^{
        UIEdgeInsets contentInset = self.tableView.contentInset;
        contentInset.top += self.headerLabel.NJ_height;
        self.tableView.contentInset = contentInset;
        //设置偏移量
        [UIView animateWithDuration:0.5 animations:^{
            self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, - self.tableView.contentInset.top);
        }];
    }];
    //发送请求,加载新数据
    [self loadNewTopics];
    NSLog(@"下拉刷新，加载新的数据");

}
#pragma mark - 结束下拉刷新
- (void)endDownDragRefreshing
{
    self.downDragRefreshStatus = NO;
    //减少内边距
    [UIView animateWithDuration:0.2 animations:^{
        UIEdgeInsets contentInset = self.tableView.contentInset;
        contentInset.top -= self.headerLabel.NJ_height;
        self.tableView.contentInset = contentInset;
    }];
    
}
#pragma mark - 开始上拉刷新
- (void)beginUpDragRefreshing
{
    //正在上拉刷新状态，则返回
    if([self isUpDragrefreshStatus])
    {
        return;
    }
    NJLog(@"上拉刷新，加载更多数据");
    //正在刷新中
    self.upDragrefreshStatus = YES;
    self.footerLable.text = NJisUpDragRefreshingText;
    //发送请求，加载更多数据
    [self loadMoreTopics];
 
}
#pragma mark - 结束上拉刷新状态
- (void)endUpDragRefreshing
{
    self.upDragrefreshStatus = NO;
    //更改文字
    self.footerLable.text = NJUpDragNotRefreshText;
}
@end
