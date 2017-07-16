//
//  NJMeVC.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/10.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJMeVC.h"
#import "NJSettingVC.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "NJSquareItem.h"
#import "NJSquareCell.h"
#import "NJWebVC.h"
#import "NJLoginRegisterVC.h"

#define NJMeUrl @"http://api.budejie.com/api/api_open.php"
#define cellWH ((NJScreenW - (column - 1) * margin) / 4)
@interface NJMeVC () <UICollectionViewDataSource,UICollectionViewDelegate>
/********* 广场 *********/
@property(nonatomic,weak)UICollectionView * square;
/********* 广场数据 *********/
@property(nonatomic,strong)NSMutableArray * squareArr;

@end

@implementation NJMeVC

static CGFloat const margin = 1;
static NSString * const ID = @"square";
static NSInteger const column = 4;

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航条
    [self setupNavBar];
    //设置表格底部视图
    [self setupFooterView];
    //获取数据
    [self loadData];
    //注册cell
    [_square registerNib:[UINib nibWithNibName:NSStringFromClass([NJSquareCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:ID];
    //设置cell间距
    
    [self setupCellSpace];
}
#pragma mark - 设置cell间距
- (void)setupCellSpace
{
    // 处理cell间距,默认tableView分组样式,有额外头部和尾部间距(18,18)
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 10;
    //默认tableView分组样式，每个cell的y都增加35 {{0, 35}, {414, 44}}
    self.tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    NSLog(@"%@",NSStringFromUIEdgeInsets(self.tableView.contentInset));
}
#pragma mark - 获取数据
- (void)loadData
{
    //1.创建管理者
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    //2.拼接参数
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    parameter[@"a"] = @"square";
    parameter[@"c"] = @"topic";
    //3.发送请求
    [manager GET:NJMeUrl parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSArray * squareData = responseObject[@"square_list"];
        //字典数组转模型数组
        NSMutableArray * squareArr = [NJSquareItem mj_objectArrayWithKeyValuesArray:squareData];
        _squareArr = squareArr;
        //使每行都完整
        [self resolveData];
        //重新设置collectionView的高度
        [self setupCollectionViewHeight];
        //刷新collection
        [self.square reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark - 设置collectionViewHeight
- (void)setupCollectionViewHeight
{
    NSInteger row = (self.squareArr.count + column - 1) / column;
    self.square.NJ_height = cellWH * row;
    //重新设置footerView的高度
    // tableView滚动范围是系统自己计算
//    self.tableView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.square.frame));
    
    self.tableView.tableFooterView = self.square;
}
#pragma mark - 使每行都完整
- (void)resolveData
{
    //计算差几个
    NSInteger several = self.squareArr.count % column;
    if(several != 0)
    {
        several = column - several;
        for (int i = 0 ; i < several; i++)
        {
            [self.squareArr addObject:[[NJSquareItem alloc]init]];
        }
    }
}
#pragma mark - 设置表格底部视图
- (void)setupFooterView
{
    /*
     用collectionView
     注意点:
     1.用流式布局
     2.只能用注册collectionViewCell
     3.使用自定义collectionViewCell
     */
    //1.创建流式布局对象
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    //1.1设置cell

    flowLayout.itemSize = CGSizeMake(cellWH, cellWH);
    flowLayout.minimumInteritemSpacing = margin;
    flowLayout.minimumLineSpacing = margin;
    //2.创建UICollectionView对象
    UICollectionView * square = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 400) collectionViewLayout:flowLayout];
    _square = square;
    square.backgroundColor = self.tableView.backgroundColor;
    //3.设置数据源
    square.dataSource = self;
    //4.设置代理
    square.delegate = self;
    //5.禁止滑动
    square.scrollEnabled = NO;
    
    self.tableView.tableFooterView = square;
}
#pragma mark - 设置导航条
- (void)setupNavBar
{
    //1.夜间模式
    UIBarButtonItem * moonBtnItem = [UIBarButtonItem itemWithNormalImage:[UIImage imageNamed:@"mine-moon-icon"] selectedImage:[UIImage imageNamed:@"mine-moon-icon-click"] target:self action:@selector(moonBtnClick:)];
    //2.设置
    UIBarButtonItem * setBtnItem = [UIBarButtonItem itemWithNormalImage:[UIImage imageNamed:@"mine-setting-icon"] highLightImage:[UIImage imageNamed:@"mine-setting-icon-click"] target:self action:@selector(settingBtnClick)];
//    NSMutableArray * itemArrM = [NSMutableArray array];
//    [itemArrM addObject:setBtnItem];
//    [itemArrM addObject:moonBtnItem];
    self.navigationItem.rightBarButtonItems = @[setBtnItem,moonBtnItem];
    //3.标题
    self.navigationItem.title = @"我的";
}
#pragma mark - 点击夜间模式按钮
- (void)moonBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
}
#pragma mark - 点击设置按钮
- (void)settingBtnClick
{
    //1.创建控制器,设置table样式为group
    
    NJSettingVC * settingVC = [[NJSettingVC alloc]initWithStyle:UITableViewStyleGrouped];
     //2.界面跳转
    [self.navigationController pushViewController:settingVC animated:YES];
}
#pragma mark - UICollectionViewDataSource方法
//有几个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.squareArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    NJSquareCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    //取出对应的模型
    NJSquareItem * squareItem = self.squareArr[indexPath.row];
    //设置cell数据
    cell.squareItem = squareItem;
    return cell;
}
#pragma mark - UITableViewDelegate方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   if(indexPath.section == 0 && indexPath.row == 0)
   {
       //跳转到登录注册界面
       NJLoginRegisterVC * loginRegisterVC = [[NJLoginRegisterVC alloc]init];
       [self presentViewController:loginRegisterVC animated:YES completion:^{
           
       }];
   }
}
#pragma mark - UICollectionViewDelegate方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 跳转界面 push 展示网页
    /*
     1.Safari openURL :自带很多功能(进度条,刷新,前进,倒退等等功能),必须要跳出当前应用
     2.UIWebView (没有功能) ,在当前应用打开网页,并且有safari,自己实现,UIWebView不能实现进度条
     3.SFSafariViewController:专门用来展示网页 需求:即想要在当前应用展示网页,又想要safari功能 iOS9才能使用
     4.WKWebView IOS8
     1.导入#import <SafariServices/SafariServices.h>
     */
    //获取数据模型
    NJSquareItem * item = self.squareArr[indexPath.row];
    if(![item.url hasPrefix:@"http"])
    {
        return;
    }
    NJWebVC * webVC = [[NJWebVC alloc]init];
    webVC.url = [NSURL URLWithString:item.url];
    //跳转界面
    [self.navigationController pushViewController:webVC animated:YES];
}
#pragma mark - SFSafariViewControllerDelegate方法

@end
