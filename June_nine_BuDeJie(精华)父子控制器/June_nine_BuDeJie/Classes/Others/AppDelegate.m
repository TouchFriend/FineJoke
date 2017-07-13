//
//  AppDelegate.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/9.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "AppDelegate.h"
#import "NJADViewController.h"
#import "NJTabBarController.h"
#import <AFNetworkReachabilityManager.h>
#import <SDImageCache.h>
@interface AppDelegate ()

@end

@implementation AppDelegate
#pragma mark - 监听状态栏的点击
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    //Pass nil to get the touch location in the window’s coordinates.
//    //为空，默认是窗口的坐标系
//    CGPoint point = [touches.anyObject locationInView:nil];
//    if(point.y <= 20)
//    {
//        NJLog(@"%@",NSStringFromCGPoint(point));
//        
//    }
//    
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //1.创建window
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //2.设置root控制器
//    NJADViewController * adVC = [[NJADViewController alloc]init];
//     // init ->  initWithNibName 1.首先判断有没有指定nibName 2.判断下有没有跟类名同名xib
//    self.window.rootViewController = adVC;
    NJTabBarController * tabBarController = [[NJTabBarController alloc]init];
    self.window.rootViewController = tabBarController;
    //3.显示窗口
    [self.window makeKeyAndVisible];
    //4.开始监听网络状态
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
//   //5.程序一启动，就清除过期缓存
//    [[SDImageCache sharedImageCache] cleanDisk];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
