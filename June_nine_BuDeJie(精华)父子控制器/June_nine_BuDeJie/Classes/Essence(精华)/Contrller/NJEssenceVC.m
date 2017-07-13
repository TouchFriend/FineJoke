//
//  NJEssenceVC.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/10.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJEssenceVC.h"
#import "NJTitleButton.h"
#import "NJAllVC.h"
#import "NJVideoVC.h"
#import "NJVoiceVC.h"
#import "NJPictureVC.h"
#import "NJWordVC.h"


@interface NJEssenceVC () <UIScrollViewDelegate>
/********* 标题栏 *********/
@property(nonatomic,weak)UIView * titleView;
/********* 前一个选中按钮 *********/
@property(nonatomic,weak)NJTitleButton * previousBtn;
/********* 下划线 *********/
@property(nonatomic,weak)UIView * underlineView;
/********* scrollView *********/
@property(nonatomic,weak)UIScrollView * contentSV;
@end
static NSInteger const underlineHeight = 2;
@implementation NJEssenceVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 把UIButton包装成UIBarButtonItem.就导致按钮点击区域扩大
    //添加子控制器(设置父子控制器)
    [self setupChildVCs];
    //设置导航条
    [self setupNavBar];
    //设置scrollView
    [self setupScrollView];
    //设置标题栏
    [self setupTitleBar];
    //添加第0个字控制器的view
    [self addSubViewControllerView:0];

}
#pragma mark - 添加子控制器
- (void)setupChildVCs
{
    //1.添加全部控制器
    [self addChildViewController:[[NJAllVC alloc]init]];
    //2.添加视频控制器
    [self addChildViewController:[[NJVideoVC alloc]init]];
    //3.添加声音控制器
    [self addChildViewController:[[NJVoiceVC alloc]init]];
    //4.添加图片控制器
    [self addChildViewController:[[NJPictureVC alloc]init]];
    //5.添加段子控制器
    [self addChildViewController:[[NJWordVC alloc]init]];
}
#pragma mark - 设置scrollView
/*
 cell的全屏穿透:
 1.tableView布满整个屏幕
 2.设置上下内边距
 */

- (void)setupScrollView
{
    //有导航条，默认会让scrollView或者其子类，tableView的内边距设置为64；
    //不允许自动修改scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView * contentSV = [[UIScrollView alloc]init];
    contentSV.frame = self.view.bounds;
    contentSV.backgroundColor = [UIColor orangeColor];
    NSUInteger count =  self.childViewControllers.count;
    contentSV.scrollsToTop = NO;//不需要点击状态栏回到顶部
    [self.view addSubview:contentSV];
    
    //设置scrollView的分页功能
    contentSV.pagingEnabled = YES;
    //取消水平指示器和垂直指示器
    contentSV.showsHorizontalScrollIndicator = NO;
    contentSV.showsVerticalScrollIndicator = NO;
    //设置代理
    contentSV.delegate = self;
    _contentSV = contentSV;
    
//    CGFloat childVcViewW = contentSV.NJ_width;
//    CGFloat childVcViewH = contentSV.NJ_height;
//    for (NSUInteger index = 0 ; index < count; index++) {
//        //取出对应子控制器的view
//        UIView * childVcView = self.childViewControllers[index].view;
//        //设置frame
//        childVcView.frame = CGRectMake(index * childVcViewW, 0, childVcViewW, childVcViewH);
//        //添加的scrollView中
//        [contentSV addSubview:childVcView];
//    }
//    //设置contentSize
    contentSV.contentSize = CGSizeMake(count * contentSV.NJ_width, 0);
}

#pragma mark - 设置标题栏
- (void)setupTitleBar
{
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0, NJNavBarMaxY, self.view.NJ_width, NJTitleBarHeight)];
    titleView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
//    titleView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:titleView];
    _titleView = titleView;
    //添加按钮
    [self setupAllBtns];
    //添加下滑线
    [self setupUnderine];
}
#pragma mark - 添加下滑线
- (void)setupUnderine
{
    NJTitleButton * titleBtn = [self.titleView.subviews firstObject];
    //标题尺寸自适应
    [titleBtn.titleLabel sizeToFit];
    CGFloat underlineH = underlineHeight;
    CGFloat underlineY = self.titleView.NJ_height - underlineH;
    CGFloat underlineW = titleBtn.titleLabel.NJ_width + 10;
    //创建下划线
    UIView * underlineView = [[UIView alloc]initWithFrame:CGRectMake(0, underlineY, underlineW , underlineH)];
    //设置中心X
    underlineView.NJ_centerX = titleBtn.NJ_centerX;
    //根据标题颜色设置颜色
    underlineView.backgroundColor = [titleBtn titleColorForState:UIControlStateSelected];
    //添加下划线
    [self.titleView addSubview:underlineView];
    _underlineView = underlineView;
}
//#pragma mark - 获取标题size
//- (CGSize)getTitleSize:(UIButton *)titleBtn
//{
//    //获取标题文字
//    NSString * title = [titleBtn titleForState:UIControlStateNormal];
//    //获取标题文字font
//    NSMutableDictionary * attributes = [NSMutableDictionary dictionary];
//    attributes[NSFontAttributeName] = [titleBtn.titleLabel font];
//    return [title sizeWithAttributes:attributes];
//}
#pragma mark - setupAllBtns
- (void)setupAllBtns
{
    NSArray * titleArr = @[@"全部",@"视频",@"声音",@"图片",@"段子"];
    NSUInteger count = titleArr.count;
    CGFloat titleBtnW = self.titleView.NJ_width * 1.0 / count;
    CGFloat titleBtnH = self.titleView.NJ_height;
    //添加标题按钮
    for (NSInteger index = 0; index < count; index++) {
        NJTitleButton * titleBtn = [NJTitleButton buttonWithType:UIButtonTypeCustom];
        //设置标题
        [titleBtn setTitle:titleArr[index] forState:UIControlStateNormal];
        //添加事件
        [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat titleBtnX = index * titleBtnW;
        //设置frame
        titleBtn.frame = CGRectMake(titleBtnX, 0, titleBtnW, titleBtnH);
        //设置Tag
        titleBtn.tag = index;
        if(index == 0)
        {
            titleBtn.selected = YES;
            _previousBtn = titleBtn;
        }
        //添加到标题栏
        [self.titleView addSubview:titleBtn];
    }
}
#pragma mark - 点击标题按钮
- (void)titleBtnClick:(NJTitleButton *)titleBtn
{
    //判断上一次被点击的按钮是否是这次被点击的按钮（重复点击）
    if(self.previousBtn == titleBtn)
    {
        //发布标题栏按钮被重复点击的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:NJTitleBarButtonDidRepeatClickNotification object:nil];
    }

    //设置前一个选中按钮状态
    self.previousBtn.selected = NO;
    //设置点击按钮选中状态
    titleBtn.selected = YES;
    CGFloat index = titleBtn.tag;
    self.previousBtn = titleBtn;
    [UIView animateWithDuration:0.25 animations:^{
        //设置下划线width
        self.underlineView.NJ_width = titleBtn.titleLabel.NJ_width + 10;
        //设置下划线centerX
        self.underlineView.NJ_centerX = titleBtn.NJ_centerX;
        //联动
        self.contentSV.contentOffset = CGPointMake(index * self.contentSV.NJ_width, self.contentSV.contentOffset.y);
    } completion:^(BOOL finished) {
        //点击标题按钮后再添加对应的子控制器的view
        [self addSubViewControllerView:titleBtn.tag];
    }];
    //遍历子控制器，将显示的子控制器的scrollsToTop设置成YES，其他子控制器设置成NO
    NSUInteger count = self.childViewControllers.count;
    for (NSUInteger i = 0; i < count ; i++) {
        //取出子控制器
        UITableViewController * childVC =  self.childViewControllers[i];
        //判断子控制器的view是否加载过
        if(![childVC isViewLoaded])
        {
            continue;//跳过
        }
        //取出子控制器的view
        UIScrollView * childView = (UIScrollView *)childVC.view;
        //判断控制器的view是否是scrollView或者scrollv的子类（tableView）
        if(![childView isKindOfClass:[UIScrollView class]])
        {
            continue;
        }
        childView.scrollsToTop = (i == index);
    }
    
}
#pragma mark - 左边按钮点击事件
- (void)gameBtnClick
{
    NJFunc;
}
#pragma mark - 右边按钮点击事件
- (void)randomBtnClick
{
    
}
#pragma mark - 设置导航条
- (void)setupNavBar
{
    //左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithNormalImage:[UIImage imageNamed:@"nav_item_game_icon"] highLightImage:[UIImage imageNamed:@"nav_item_game_click_icon"] target:self action:@selector(gameBtnClick)];
    //右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithNormalImage:[UIImage imageNamed:@"navigationButtonRandom"] highLightImage:[UIImage imageNamed:@"navigationButtonRandomClick"] target:self action:@selector(randomBtnClick)];
    //中间标题
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainTitle"]];
}
#pragma mark - UIScrollViewDelegate方法
//用户放开手后，scrollView停止滚动后调用(完成减速后调用)
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //获取按钮索引
    NSInteger index =  scrollView.contentOffset.x / scrollView.NJ_width;
    //获取对应的按钮
    //方法一
    NJTitleButton * titleBtn = self.titleView.subviews[index];
    /*
     方法二有缺陷:viewWithTag:用递归查询，包括自己，查看tag是否跟给定的tag一致。
     而控件默认的都是0，所以传回自己， 所以传0时会特技
     */
//    NJTitleButton * titleBtn = [self.titleView viewWithTag:index];
    
    //点击对应的按钮(联动)
    [self titleBtnClick:titleBtn];
}
#pragma mark - 添加子控制器的view
- (void)addSubViewControllerView:(NSUInteger)index
{
    //2.获取对应的控制器的view
    UIView * subView = self.childViewControllers[index].view;
    //如果已经加载过，则直接返回
    //方式一
    if(subView.superview)
    {
        return;
    }
    CGFloat contentSvWidth = self.contentSV.NJ_width;
    subView.frame = CGRectMake(index * contentSvWidth, 0, contentSvWidth, self.contentSV.NJ_height);
    //4.添加子view到scrollView中
    [self.contentSV addSubview:subView];

//    //方式二
//    if(subView.window)
//    {
//        return;
//    }
    //方法三
//    UIViewController * subVC = self.childViewControllers[index];
//    if([subVC isViewLoaded])
//    {
//        return;
//    }
//    UIView * subView = subVC.view;
    //3.设置frame
}
@end
