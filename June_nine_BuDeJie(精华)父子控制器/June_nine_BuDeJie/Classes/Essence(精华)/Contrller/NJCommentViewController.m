//
//  NJCommentViewController.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/7/14.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJCommentViewController.h"
#import "NJCommentCell.h"
#import "NJHTTPSessionManager.h"
#import "NJTopic.h"
#import <SVProgressHUD.h>
#import "NJComment.h"
#import <MJExtension/MJExtension.h>
#import "NJTableViewHeaderFooterView.h"
#import "NJTopicCell.h"
#import <MJRefresh/MJRefresh.h>
#import "NJRefreshNormalHeader.h"
#import "NJRefreshAutoNormalFooter.h"
#import "NJUser.h"

@interface NJCommentViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/********* 会话管理者 *********/
@property(nonatomic,strong)NJHTTPSessionManager * manager;
/********* 最热评论 *********/
@property(nonatomic,strong)NSArray * hotComments;
@property (weak, nonatomic) IBOutlet UIView *toolView;

/********* 数据模型 *********/
@property(nonatomic,strong)NSMutableArray * commentsArrM;
/********* 获得选中的评论 *********/
- (NJComment *)selectedComment;
@end

@implementation NJCommentViewController
static NSString * const ID = @"NJCommentCell";
static NSString * const HeaderFooterID = @"NJTableViewHeaderFooterView";
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航条
    [self setupNavBar];
    //设置表格
    [self setupTable];
    //设置刷新
    [self setupRefresh];
    //监听键盘的弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}
#pragma mark - 懒加载
- (NJHTTPSessionManager *)manager
{
    if(_manager == nil)
    {
        _manager = [NJHTTPSessionManager manager];
    }
    return _manager;
}
- (void)setupNavBar
{
    //1.标题
    self.title = @"详情";
    //2.右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithNormalImage:[UIImage imageNamed:@"comment_nav_item_share_icon"] highLightImage:[UIImage imageNamed:@"comment_nav_item_share_icon_click"] target:self action:@selector(shareBtnClick:)];
}
#pragma mark - 设置表格
- (void)setupTable
{
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NJCommentCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ID];
    //注册HeaderFooterView
    [self.tableView registerClass:[NJTableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:HeaderFooterID];
    //取消分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //处理数据模型，隐藏最热评论
    if(self.topic.top_cmt.count != 0)
    {
        //字典数组转模型
        self.hotComments = [NJComment mj_objectArrayWithKeyValuesArray:self.topic.top_cmt];
        self.topic.top_cmt = nil;
        self.topic.cellHeight = 0;//让帖子的高度重新计算
    }
    //添加表格头部视图
    NJTopicCell * cell = [NJTopicCell viewFromXib];
    //设置数据模型
    cell.topic = self.topic;
    cell.frame = CGRectMake(0, 0, NJScreenW, cell.topic.cellHeight);
    
    UIView * tableHeaderView = [[UIView alloc]init];
    tableHeaderView.NJ_height = cell.NJ_height;
    [tableHeaderView addSubview:cell];
    self.tableView.tableHeaderView = tableHeaderView;
}
- (void)setupRefresh
{
    //下拉刷新
    self.tableView.mj_header = [NJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    //首次刷新
    [self.tableView.mj_header beginRefreshing];
    //上拉刷新
    self.tableView.mj_footer = [NJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
}
#pragma mark - 请求下拉加载的数据
- (void)loadNewComments
{
    //取消前一次的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"dataList";
    parameters[@"c"] = @"comment";
    parameters[@"data_id"] = @(self.topic.ID);
    parameters[@"hot"] = @(1);
    //发送请求
    [self.manager GET:NJCommonURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task,  NSDictionary *  _Nullable responseObject) {
        //设置属性吗跟key值的映射
        [NJComment mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"ID" : @"id",
                     };
        }];
        //保存最热评论
        self.hotComments = [NJComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        //数据转模型(最新的评论)
        self.commentsArrM = [NJComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        //重新加载数据
        [self.tableView reloadData];
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NJLog(@"%@",error);
        if(error.code != NSURLErrorCancelled)
        {
            [SVProgressHUD showErrorWithStatus:@"网络繁忙,请稍后再试！"];
        }
        //结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
}
#pragma mark - 请求上拉加载的更多新数据
- (void)loadMoreComments
{
    //取消前一次的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"dataList";
    parameters[@"c"] = @"comment";
    parameters[@"data_id"] = @(self.topic.ID);
//    parameters[@"hot"] = @(1);
    NJComment * comment = self.commentsArrM.lastObject;
    parameters[@"lastcid"] = comment.ID;
    //发送请求
    [self.manager GET:NJCommonURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task,  NSDictionary *  _Nullable responseObject) {
        //设置属性吗跟key值的映射
        [NJComment mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"ID" : @"id",
                     };
        }];
        //数据转模型(最新的评论)(可能后台删了一些数据，但没把总数改回来)
        if(responseObject.count == 0)
        {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];//没有更多数据
            return;
        }
        NSArray * moreComment = [NJComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.commentsArrM addObjectsFromArray:moreComment];
        //重新加载数据
        [self.tableView reloadData];
        //结束刷新
        if(self.commentsArrM.count >= [responseObject[@"total"] integerValue])
        {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];//没有更多数据
        }
        else
        {
          [self.tableView.mj_footer endRefreshing];
        }
        
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

#pragma mark - 分享按钮被点击
- (void)shareBtnClick:(UIBarButtonItem *)barButtonItem
{
    
}

#pragma mark - UITableViewDataSource方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.hotComments.count != 0)
    {
        return 2;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0 && self.hotComments.count != 0)
    {
        return self.hotComments.count;
    }
    return self.commentsArrM.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NJCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    NSLog(@"%p----%ld",cell,indexPath.row);
    //设置cell的选中样式
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //设置cell的数据
    NSArray * comments = self.commentsArrM;
    if(indexPath.section == 0 && self.hotComments.count != 0)
    {
        comments = self.hotComments;
    }
    cell.comment = comments[indexPath.row];
    return cell;
    
}
#pragma mark - UITableViewDelegate方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取出对应的模型
    NJComment * comment = self.commentsArrM[indexPath.row];
    return comment.cellHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NJTableViewHeaderFooterView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderFooterID];
    //设置数据
    if(section == 0 && self.hotComments.count != 0)
    {
        headerView.title = @"最热评论";
    }
    else
    {
        headerView.title = @"最新评论";
    }
    return headerView;
}
//设置headerView的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取出对应的cell
    NJCommentCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    //创建菜单
    UIMenuController * menu = [UIMenuController sharedMenuController];
    //设置菜单选项
    menu.menuItems = @[
                       [[UIMenuItem alloc]initWithTitle:@"顶" action:@selector(selectDing:)],
                       [[UIMenuItem alloc]initWithTitle:@"回复" action:@selector(selectReply:)],
                       [[UIMenuItem alloc]initWithTitle:@"举报" action:@selector(selectWarning:)],
                       ];
    CGRect rect = CGRectMake(0, cell.NJ_height * 0.5, cell.NJ_width, 1);
    //将菜单添加到cell上
    [menu setTargetRect:rect inView:cell];
    //显示菜单
    [menu setMenuVisible:YES animated:YES];
}
#pragma mark - 监听键盘的出现
/*
 {name = UIKeyboardWillChangeFrameNotification; userInfo = {
 UIKeyboardAnimationCurveUserInfoKey = 7;
 UIKeyboardAnimationDurationUserInfoKey = "0.25";
 UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {414, 226}}";
 UIKeyboardCenterBeginUserInfoKey = "NSPoint: {207, 849}";
 UIKeyboardCenterEndUserInfoKey = "NSPoint: {207, 623}";
 UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 736}, {414, 226}}";
 UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 510}, {414, 226}}";
 UIKeyboardIsLocalUserInfoKey = 1;
 }}
 */
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    CGFloat duration = [notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect endFrame = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    [UIView animateWithDuration:duration animations:^{
        // 工具条平移的距离 == 键盘最终的Y值 - 屏幕高度
        self.toolView.transform = CGAffineTransformMakeTranslation(0, endFrame.origin.y - NJScreenH);
    }];
}
#pragma mark - UIMenuController处理
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
//解决粘贴板跟菜单的冲突
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if(!self.isFirstResponder)//说明输入框是第一响应者
    {
        if(action == @selector(selectDing:)
           || action == @selector(selectReply:)
           || action == @selector(selectWarning:))
        {
            return NO;
        }
    }
    return [super canPerformAction:action withSender:sender];
}
//获得选中的评论
- (NJComment *)selectedComment
{
    NSIndexPath * indexPath = self.tableView.indexPathForSelectedRow;
    NSArray * comments = self.commentsArrM;
    if(indexPath.section == 0 && self.hotComments.count != 0)//有最热评论
    {
        comments = self.hotComments;
    }
    return comments[indexPath.row];
}
- (void)selectDing:(UIMenuController *)menuController
{
    NJLog(@"%@----%@",[self selectedComment].user.username,[self selectedComment].content);
}
- (void)selectReply:(UIMenuController *)menuController
{
    NJLog(@"%@----%@",self.selectedComment.user.username,self.selectedComment.content);
}
- (void)selectWarning:(UIMenuController *)menuController
{
    NJLog(@"%@----%@",self.selectedComment.user.username,self.selectedComment.content);
}
- (void)dealloc
{
    //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIKeyboardWillChangeFrameNotification" object:nil];
}
@end
