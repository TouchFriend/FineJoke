//
//  NJTabBarController.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/10.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJTabBarController.h"
#import "NJEssenceVC.h"
#import "NJNewVC.h"
#import "NJPublicVC.h"
#import "NJFriendTrendVC.h"
#import "NJMeVC.h"
#import "UIImage+NJImage.h"
#import "NJTabBar.h"
#import "NJNavigationVC.h"
@interface NJTabBarController ()

@end

@implementation NJTabBarController
+ (void)load
{
    //  - 获取指定类下面的控件，只会设置指定类，不会更改系统的属性
    UITabBarItem * tabBarItem = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    // 设置按钮选中标题的颜色:富文本:描述一个文字颜色,字体,阴影,空心,图文混排
    // 创建一个描述文本属性的字典
    NSMutableDictionary * dicM = [NSMutableDictionary dictionary];
    //设置字体颜色
    [dicM setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    [tabBarItem setTitleTextAttributes:dicM forState:UIControlStateSelected];
    //设置字体大小:只有设置正常状态下,才会有效果
    NSMutableDictionary * fontDicM = [NSMutableDictionary dictionary];
    [fontDicM setObject:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName];
    [tabBarItem setTitleTextAttributes:fontDicM forState:UIControlStateNormal];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //1.添加子控制器
    [self setupAllChildViewController];
    //2.设置tabBarItem标题
    [self setupAllTabBarItems];
    // 3.自定义tabBar
//    NSLog(@"%@",self.tabBar.subviews);
    [self setupTabBar];
//    NSLog(@"%@",self.tabBar.subviews);
    // tabBar上按钮并不是在viewDidLoad添加的
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)setupTabBar
{
    NJTabBar * tabBar = [[NJTabBar alloc]init];
    [self setValue:tabBar forKey:@"tabBar"];
}
#pragma mark -添加子控制器]]
- (void)setupAllChildViewController
{
    //1.精华
    NJEssenceVC * essenceVC = [[NJEssenceVC alloc]init];
    NJNavigationVC * nav1 = [[NJNavigationVC alloc]initWithRootViewController:essenceVC];
    [self addChildViewController:nav1];
    //2.新帖
    NJNewVC * newVC = [[NJNewVC alloc]init];
    NJNavigationVC * nav2 = [[NJNavigationVC alloc]initWithRootViewController:newVC];
    [self addChildViewController:nav2];
//    //3.发布
//    NJPublicVC * publicVC = [[NJPublicVC alloc]init];
//    [self addChildViewController:publicVC];
    
    //4.关注
    NJFriendTrendVC * friendTrendVC = [[NJFriendTrendVC alloc]init];
    NJNavigationVC * nav3 = [[NJNavigationVC alloc]initWithRootViewController:friendTrendVC];
    [self addChildViewController:nav3];
    //5.我 用StoryBoard加载
    UIStoryboard * meStoryboard = [UIStoryboard storyboardWithName:NSStringFromClass([NJMeVC class]) bundle:[NSBundle mainBundle]];
    NJMeVC * meVC = [meStoryboard instantiateInitialViewController];
    NJNavigationVC * nav4 = [[NJNavigationVC alloc]initWithRootViewController:meVC];
    [self addChildViewController:nav4];
}
#pragma mark - 设置tabBarItem标题
- (void)setupAllTabBarItems
{
    //1.精华
    NJNavigationVC * nav = self.childViewControllers[0];
    nav.tabBarItem.title = @"精华";
    nav.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
    //更改图片的渲染模式
    nav.tabBarItem.selectedImage = [UIImage imageOriginNamed:@"tabBar_essence_click_icon"];
    //2.新帖
    NJNavigationVC * nav1 = self.childViewControllers[1];
    nav1.tabBarItem.title = @"新帖";
    nav1.tabBarItem.image = [UIImage imageNamed:@"tabBar_new_icon"];
    nav1.tabBarItem.selectedImage = [UIImage imageOriginNamed:@"tabBar_new_click_icon"];
//    //3.发布
//    NJPublicVC * publicVC = self.childViewControllers[2];
//    publicVC.tabBarItem.image = [UIImage imageOriginNamed:@"tabBar_publish_icon"];
//    publicVC.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
//    publicVC.tabBarItem.selectedImage = [UIImage imageOriginNamed:@"tabBar_publish_click_icon"];
    //4.关注
    NJNavigationVC * nav3 = self.childViewControllers[2];
    nav3.tabBarItem.title = @"关注";
    nav3.tabBarItem.image = [UIImage imageNamed:@"tabBar_friendTrends_icon"];
    nav3.tabBarItem.selectedImage = [UIImage imageOriginNamed:@"tabBar_friendTrends_click_icon"];
    //5.我
    NJNavigationVC * nav4 = self.childViewControllers[3];
    nav4.tabBarItem.title = @"我";
    nav4.tabBarItem.image = [UIImage imageNamed:@"tabBar_me_icon"];
    nav4.tabBarItem.selectedImage = [UIImage imageOriginNamed:@"tabBar_essence_click_icon"];
}
@end
