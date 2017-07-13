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

#define TitleHeight 40
#define UnderlineHeight 2
@interface NJEssenceVC ()
/********* 标题栏 *********/
@property(nonatomic,weak)UIView * titleView;
/********* 前一个选中按钮 *********/
@property(nonatomic,weak)NJTitleButton * previousBtn;
/********* 下划线 *********/
@property(nonatomic,weak)UIView * underlineView;
@end

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
- (void)setupScrollView
{
    
    //有导航条，默认会让scrollView或者其子类，tableView的内边距设置为64；
    //不允许自动修改scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView * contentSV = [[UIScrollView alloc]init];
    contentSV.frame = self.view.bounds;
    contentSV.backgroundColor = [UIColor orangeColor];
    NSUInteger count =  self.childViewControllers.count;
    [self.view addSubview:contentSV];
    CGFloat childVcViewW = contentSV.NJ_width;
    CGFloat childVcViewH = contentSV.NJ_height;
    
    for (NSUInteger index = 0 ; index < count; index++) {
        //添加
        UIView * childVcView = self.childViewControllers[index].view;
        childVcView.frame = CGRectMake(index * childVcViewW, 0, childVcViewW, childVcViewH);
        [contentSV addSubview:childVcView];
    }
    //设置contentSize
    contentSV.contentSize = CGSizeMake(count * contentSV.NJ_width, 0);
}

#pragma mark - 设置标题栏
- (void)setupTitleBar
{
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.NJ_width, TitleHeight)];
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
    CGFloat underlineH = UnderlineHeight;
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
    //设置前一个选中按钮状态
    self.previousBtn.selected = NO;
    //设置点击按钮选中状态
    titleBtn.selected = YES;
    
    self.previousBtn = titleBtn;
    [UIView animateWithDuration:0.25
                     animations:^{
        //设置下划线width
        self.underlineView.NJ_width = titleBtn.titleLabel.NJ_width + 10;
        //设置下划线centerX
        self.underlineView.NJ_centerX = titleBtn.NJ_centerX;
    }];
    
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

@end
