//
//  NJLaunchView.m
//  July_Eight_PaintCode
//
//  Created by TouchWorld on 2017/7/8.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJLaunchView.h"
#import "NJTabBarController.h"

@interface NJLaunchView ()
@property (strong, nonatomic) UIView *launchView;
@end
@implementation NJLaunchView
+ (instancetype)addLaunchView
{
    //1.创建启动视图
    NJLaunchView * launchView = [[NJLaunchView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //2.将启动视图添加到窗口中
    UIWindow * mainWindow = [UIApplication sharedApplication].keyWindow;
    [mainWindow addSubview:launchView];
    //3.向启动视图添加图层
    [launchView addLayerToLaunchView];
    return launchView;
}
#pragma mark - 懒加载
- (UIView *)launchView
{
    if(_launchView == nil)
    {
        UIView * launchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
        launchView.backgroundColor = [UIColor clearColor];//透明色
        launchView.center = self.center;
        [self addSubview:launchView];
        _launchView = launchView;
    }
    return  _launchView;
}
#pragma mark - 添加启动视图
- (void)addLayerToLaunchView
{
    self.backgroundColor = [UIColor colorWithRed:0.18 green:0.70 blue:0.90 alpha:1.0];//蓝色
    //绘制图层
    CAShapeLayer * layer  = [[CAShapeLayer alloc]init];
    layer.path = [self bezierPath].CGPath;
    layer.bounds = CGPathGetBoundingBox(layer.path);
    layer.position = CGPointMake(self.launchView.bounds.size.width / 2, self.launchView.bounds.size.height/ 2);
    layer.fillColor = [UIColor whiteColor].CGColor;
    [self.launchView.layer addSublayer:layer];
    //延迟执行动画代码
    [self performSelector:@selector(startLaunch) withObject:nil afterDelay:1.0];
}
#pragma mark - 实现动画效果
- (void)startLaunch
{
    [UIView animateWithDuration:1.0 animations:^{
        //先缩小launchView
        self.launchView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 animations:^{
            //再放大launchView
            self.launchView.transform = CGAffineTransformMakeScale(50, 50);
            self.launchView.alpha = 0;
        } completion:^(BOOL finished) {
            //移除view
            [self.launchView removeFromSuperview];
            [self removeFromSuperview];
            //销毁广告界面,显示主界面
            [UIApplication sharedApplication].keyWindow.rootViewController = [[NJTabBarController alloc]init];

        }];
        
    }];
}
#pragma mark - 绘制图像
- (UIBezierPath *)bezierPath
{
    //// Color Declarations
    UIColor* strokeColor = [UIColor colorWithRed: 0.592 green: 0.592 blue: 0.592 alpha: 1];
    
    //// Page-1
    {
        //// Path Drawing
        UIBezierPath* pathPath = [UIBezierPath bezierPath];
        [pathPath moveToPoint: CGPointMake(1.25, 32.75)];
        [pathPath addLineToPoint: CGPointMake(6.09, 37.63)];
        [pathPath addLineToPoint: CGPointMake(8.53, 44.93)];
        [pathPath addLineToPoint: CGPointMake(13.36, 50.81)];
        [pathPath addLineToPoint: CGPointMake(21.71, 55.27)];
        [pathPath addLineToPoint: CGPointMake(34.05, 61.99)];
        [pathPath addLineToPoint: CGPointMake(50.54, 69.37)];
        [pathPath addLineToPoint: CGPointMake(67.35, 76.72)];
        [pathPath addLineToPoint: CGPointMake(78.25, 82.19)];
        [pathPath addLineToPoint: CGPointMake(86.35, 86.83)];
        [pathPath addLineToPoint: CGPointMake(85.33, 93.73)];
        [pathPath addLineToPoint: CGPointMake(83.67, 96.73)];
        [pathPath addLineToPoint: CGPointMake(84.31, 100.84)];
        [pathPath addLineToPoint: CGPointMake(84.82, 107.29)];
        [pathPath addLineToPoint: CGPointMake(87.95, 112.9)];
        [pathPath addLineToPoint: CGPointMake(88.65, 119.57)];
        [pathPath addLineToPoint: CGPointMake(93.08, 124.77)];
        [pathPath addLineToPoint: CGPointMake(92.97, 128.52)];
        [pathPath addLineToPoint: CGPointMake(98.41, 133.62)];
        [pathPath addLineToPoint: CGPointMake(103.26, 139.54)];
        [pathPath addLineToPoint: CGPointMake(106.08, 140.19)];
        [pathPath addLineToPoint: CGPointMake(107.22, 137.83)];
        [pathPath addLineToPoint: CGPointMake(105.2, 130.67)];
        [pathPath addLineToPoint: CGPointMake(101.3, 123.04)];
        [pathPath addLineToPoint: CGPointMake(101.22, 116.93)];
        [pathPath addLineToPoint: CGPointMake(102.14, 107.5)];
        [pathPath addLineToPoint: CGPointMake(102.14, 99.3)];
        [pathPath addLineToPoint: CGPointMake(105.3, 92.89)];
        [pathPath addLineToPoint: CGPointMake(110.02, 89.64)];
        [pathPath addLineToPoint: CGPointMake(114.85, 90.62)];
        [pathPath addLineToPoint: CGPointMake(114.06, 96.41)];
        [pathPath addLineToPoint: CGPointMake(111.92, 101.79)];
        [pathPath addLineToPoint: CGPointMake(113.02, 104.36)];
        [pathPath addLineToPoint: CGPointMake(117.26, 107.02)];
        [pathPath addLineToPoint: CGPointMake(118.43, 110.64)];
        [pathPath addLineToPoint: CGPointMake(120.56, 113.82)];
        [pathPath addLineToPoint: CGPointMake(121.35, 119.51)];
        [pathPath addLineToPoint: CGPointMake(123.82, 122.55)];
        [pathPath addLineToPoint: CGPointMake(129.56, 127.05)];
        [pathPath addLineToPoint: CGPointMake(136.1, 131.16)];
        [pathPath addLineToPoint: CGPointMake(144.54, 140.25)];
        [pathPath addLineToPoint: CGPointMake(154.73, 147.64)];
        [pathPath addLineToPoint: CGPointMake(165.15, 152.3)];
        [pathPath addLineToPoint: CGPointMake(169.87, 152.9)];
        [pathPath addLineToPoint: CGPointMake(169.87, 148.31)];
        [pathPath addLineToPoint: CGPointMake(162.86, 138.48)];
        [pathPath addLineToPoint: CGPointMake(154.95, 129.75)];
        [pathPath addLineToPoint: CGPointMake(151.18, 120.62)];
        [pathPath addLineToPoint: CGPointMake(147.82, 108.63)];
        [pathPath addLineToPoint: CGPointMake(143.07, 101.69)];
        [pathPath addLineToPoint: CGPointMake(140.4, 97.75)];
        [pathPath addLineToPoint: CGPointMake(151.28, 99.4)];
        [pathPath addLineToPoint: CGPointMake(162.08, 100.08)];
        [pathPath addLineToPoint: CGPointMake(169.84, 100.34)];
        [pathPath addLineToPoint: CGPointMake(182.74, 98.15)];
        [pathPath addLineToPoint: CGPointMake(196.79, 91.1)];
        [pathPath addLineToPoint: CGPointMake(215.21, 81.19)];
        [pathPath addLineToPoint: CGPointMake(229.32, 69.8)];
        [pathPath addLineToPoint: CGPointMake(241.36, 58.87)];
        [pathPath addLineToPoint: CGPointMake(254.49, 48.38)];
        [pathPath addLineToPoint: CGPointMake(270.74, 40.76)];
        [pathPath addLineToPoint: CGPointMake(284.05, 38.79)];
        [pathPath addLineToPoint: CGPointMake(298.84, 38.75)];
        [pathPath addLineToPoint: CGPointMake(306.92, 37.78)];
        [pathPath addLineToPoint: CGPointMake(315.68, 31.72)];
        [pathPath addCurveToPoint: CGPointMake(318.59, 28.35) controlPoint1: CGPointMake(317.16, 30.52) controlPoint2: CGPointMake(318.13, 29.4)];
        [pathPath addCurveToPoint: CGPointMake(318.59, 25.02) controlPoint1: CGPointMake(319.05, 27.3) controlPoint2: CGPointMake(319.05, 26.19)];
        [pathPath addLineToPoint: CGPointMake(307.47, 29.08)];
        [pathPath addLineToPoint: CGPointMake(300.91, 29.94)];
        [pathPath addLineToPoint: CGPointMake(288.87, 26.67)];
        [pathPath addLineToPoint: CGPointMake(280.4, 25.29)];
        [pathPath addLineToPoint: CGPointMake(271.51, 25.95)];
        [pathPath addCurveToPoint: CGPointMake(269.97, 21.35) controlPoint1: CGPointMake(270.68, 24.23) controlPoint2: CGPointMake(270.17, 22.7)];
        [pathPath addCurveToPoint: CGPointMake(269.97, 15.5) controlPoint1: CGPointMake(269.77, 20.01) controlPoint2: CGPointMake(269.77, 18.06)];
        [pathPath addLineToPoint: CGPointMake(274.52, 8.56)];
        [pathPath addCurveToPoint: CGPointMake(279.1, 5.16) controlPoint1: CGPointMake(276.69, 7.11) controlPoint2: CGPointMake(278.21, 5.98)];
        [pathPath addCurveToPoint: CGPointMake(280.4, 3.09) controlPoint1: CGPointMake(279.98, 4.34) controlPoint2: CGPointMake(280.41, 3.65)];
        [pathPath addLineToPoint: CGPointMake(277.94, 1)];
        [pathPath addLineToPoint: CGPointMake(267.51, 6.48)];
        [pathPath addLineToPoint: CGPointMake(260.85, 13.43)];
        [pathPath addLineToPoint: CGPointMake(254.09, 22.7)];
        [pathPath addLineToPoint: CGPointMake(243.41, 34.03)];
        [pathPath addLineToPoint: CGPointMake(225.98, 42.59)];
        [pathPath addLineToPoint: CGPointMake(210, 46.63)];
        [pathPath addLineToPoint: CGPointMake(212.33, 41.3)];
        [pathPath addLineToPoint: CGPointMake(209.29, 40.76)];
        [pathPath addLineToPoint: CGPointMake(199.57, 44.55)];
        [pathPath addLineToPoint: CGPointMake(183.04, 48.39)];
        [pathPath addLineToPoint: CGPointMake(172.48, 46.83)];
        [pathPath addLineToPoint: CGPointMake(160.2, 43.94)];
        [pathPath addLineToPoint: CGPointMake(149.5, 42.34)];
        [pathPath addLineToPoint: CGPointMake(132.97, 36.81)];
        [pathPath addLineToPoint: CGPointMake(114.2, 31.36)];
        [pathPath addLineToPoint: CGPointMake(96.06, 27.48)];
        [pathPath addLineToPoint: CGPointMake(70.02, 26.74)];
        [pathPath addLineToPoint: CGPointMake(32.76, 24.49)];
        [pathPath addLineToPoint: CGPointMake(13.65, 25.29)];
        [pathPath addLineToPoint: CGPointMake(4.91, 25.88)];
        [pathPath addLineToPoint: CGPointMake(1.65, 28.35)];
        [pathPath addLineToPoint: CGPointMake(1.25, 32.75)];
        [pathPath closePath];
        [strokeColor setStroke];
        pathPath.lineWidth = 1;
        pathPath.miterLimit = 4;
        [pathPath stroke];
        return pathPath;
    }
}
@end
