//
//  NJNavigationVC.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/12.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJNavigationVC.h"
@interface NJNavigationVC () <UIGestureRecognizerDelegate>

@end

@implementation NJNavigationVC
+ (void)load
{
    // 只要是通过模型设置,都是通过富文本设置
    // 设置导航条标题 => UINavigationBar
    UINavigationBar * navigationBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    NSMutableDictionary * attrDicM = [NSMutableDictionary dictionary];
    //设置标题字体大小
    attrDicM[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20.0];
    [navigationBar setTitleTextAttributes:attrDicM];
    //设置导航条背景
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];

}
/*
 <UIScreenEdgePanGestureRecognizer: 0x7fa3cb52a2b0; state = Possible; delaysTouchesBegan = YES; view = <UILayoutContainerView 0x7fa3cb413450>; target= <(action=handleNavigationTransition:, target=<_UINavigationInteractiveTransition 0x7fa3cb52a170>)>>
 delegate :<_UINavigationInteractiveTransition: 0x7fc13fc27c50>
 UIScreenEdgePanGestureRecognizer
 target:_UINavigationInteractiveTransition
 action:handleNavigationTransition:
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置为空，会出现假死状态 假死状态:程序还在运行,但是界面死了.
//    NSLog(@"%@",self.interactivePopGestureRecognizer);
//    NSLog(@"%@",self.interactivePopGestureRecognizer.delegate);
    //1.创建手势
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    //2.添加手势
    [self.view addGestureRecognizer:panGesture];
    //3.设置代理 控制手势什么时候触发,只有非根控制器才需要触发手势
    panGesture.delegate = self;
    //关闭默认的左划返回
    self.interactivePopGestureRecognizer.enabled = NO;
    
    
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //为下一个界面统一设置返回按钮样式
    //判断是否是根控制器
    if(self.childViewControllers.count > 0)
    {
        //为下一个界面统一设置返回按钮样式
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithNormalImage:[UIImage imageNamed:@"navigationButtonReturn"] highLightImage:[UIImage imageNamed:@"navigationButtonReturnClick"] target:self action:@selector(back) title:@"返回"];
        //隐藏底部TabBar（跳转前才有效）
        viewController.hidesBottomBarWhenPushed = YES;
    }
    //跳转界面
    [super pushViewController:viewController animated:animated];
}
- (void)back
{
    [self popViewControllerAnimated:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //不是根控制器，才有左划返回
    return self.childViewControllers.count > 1;
}

@end
