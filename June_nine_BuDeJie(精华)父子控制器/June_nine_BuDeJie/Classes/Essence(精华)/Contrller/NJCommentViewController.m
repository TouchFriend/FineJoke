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

@interface NJCommentViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/********* 会话管理者 *********/
@property(nonatomic,strong)NJHTTPSessionManager * manager;
/********* 最热评论 *********/
@property(nonatomic,strong)NSArray * hotComment;

/********* 数据模型 *********/
@property(nonatomic,strong)NSMutableArray * commentsArrM;

@end

@implementation NJCommentViewController
static NSString * const ID = @"NJCommentCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航条
    [self setupNavBar];
    
    //设置表格
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NJCommentCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ID];
    //下载数据
    [self downloadData];
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
- (void)downloadData
{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"dataList";
    parameters[@"c"] = @"comment";
    parameters[@"data_id"] = @(self.topic.ID);
    parameters[@"hot"] = @(1);
    [self.manager GET:NJCommonURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * responseObject) {
        //设置属性吗跟key值的映射
        [NJTopic mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"ID" : @"id",
                     };
        }];
        //保存最热评论
        self.hotComment = responseObject[@"hot"];
        //数据转模型(最新的评论)
        self.commentsArrM = [NJComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        //重新加载数据
        [self.tableView reloadData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(error.code != NSURLErrorCancelled)
        {
            [SVProgressHUD showErrorWithStatus:@"网络繁忙,请稍后再试！"];
        }

    }];
}
- (void)setupNavBar
{
    //1.标题
    self.title = @"详情";
    //2.右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithNormalImage:[UIImage imageNamed:@"comment_nav_item_share_icon"] highLightImage:[UIImage imageNamed:@"comment_nav_item_share_icon_click"] target:self action:@selector(shareBtnClick:)];
}


#pragma mark - 分享按钮被点击
- (void)shareBtnClick:(UIBarButtonItem *)barButtonItem
{
    
}

#pragma mark - UITableViewDataSource方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentsArrM.count;
}
#pragma mark - UITableViewDelegate方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NJCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    NSLog(@"%p----%ld",cell,indexPath.row);
    cell.comment = self.commentsArrM[indexPath.row];
    return cell;
}
@end
