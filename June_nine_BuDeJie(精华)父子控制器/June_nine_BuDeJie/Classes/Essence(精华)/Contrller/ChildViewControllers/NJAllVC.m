//
//  NJAllVC.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/19.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJAllVC.h"

@interface NJAllVC ()
/********* footerView *********/
@property(nonatomic,weak)UIView * footerView;
/********* footerLable *********/
@property(nonatomic,weak)UILabel * footerLable;
/********* 是否处于刷新状态 *********/
@property(nonatomic,assign,getter=isRefreshStatus)BOOL refreshStatus;
/********* 数据量 *********/
@property(nonatomic,assign)NSInteger dataCount;

@end

@implementation NJAllVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //请求数据
    self.dataCount = 15;
    self.tableView.backgroundColor = NJRandomColor;
    self.tableView.contentInset = UIEdgeInsetsMake(NJNavBarMaxY + NJTitleBarHeight, 0, NJTabBarHeight, 0);
    //监听TabBarButton被重复点击的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidRepeatClick) name:NJTabBarButtonDidRepeatClickNotification object:nil];
    //监听标题栏按钮的点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleBarButtonDidRepeatClick) name:NJTitleBarButtonDidRepeatClickNotification object:nil];
    //设置上拉刷新
    [self setupRefresh];
    //设置滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
}
#pragma marl - 设置上拉刷新
- (void)setupRefresh
{
    UIView * footerView = [[UIView alloc]init];
    footerView.frame = CGRectMake(0, 0, self.tableView.NJ_width, 44);
    footerView.backgroundColor = [UIColor redColor];
    self.footerView = footerView;
    
    UILabel * footerLable = [[UILabel alloc]initWithFrame:footerView.bounds];
    footerLable.text = NJNotRefreshText;
    footerLable.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:footerLable];
    self.footerLable = footerLable;

    self.tableView.tableFooterView = footerView;
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
    NJFunc;
}
#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //判断数据量是否为0，为0隐藏footerView
    self.footerView.hidden = (self.dataCount == 0);
    return self.dataCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@-%zd", self.class, indexPath.row];
    return cell;
}
#pragma mark - dealloc
- (void)dealloc
{
    //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - TableViewDelegate方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //// 还没有任何内容的时候，不需要判断（0.000000,49.000000,716.000000）
    if(self.tableView.contentSize.height == 0)
    {
        return;
    }
    //正在刷新状态，则返回
    if([self isRefreshStatus])
    {
        return;
    }
    //判断是否拉到最下面 (内容高度 + 底部内边距 - 可视范围高度（frame高度）)
    CGFloat offsetY = self.tableView.contentSize.height + self.tableView.contentInset.bottom - self.tableView.NJ_height ;
    if(self.tableView.contentOffset.y >= offsetY)
    {
        NJLog(@"发送请求，加载数据");
        //正在刷新中
        self.refreshStatus = YES;
        self.footerLable.text = NJisRefreshingText;
        //发送请求，加载数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //获取了数据
            self.dataCount += 5;
            //刷新表格
            [self.tableView reloadData];
            
            //结束刷新状态
            self.refreshStatus = NO;
            //更改文字
            self.footerLable.text = NJNotRefreshText;
            
            
            
        });
    }
    }
@end
