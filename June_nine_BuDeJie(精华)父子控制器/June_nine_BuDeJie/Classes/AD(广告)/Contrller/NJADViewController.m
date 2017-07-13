//
//  NJADViewController.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/12.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJADViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "NJADItem.h"
#import <MJExtension/MJExtension.h>
#import <UIImageView+WebCache.h>
#import "NJTabBarController.h"
#define ADUrl @"http://mobads.baidu.com/cpro/ui/mads.php"
#define code2 @"phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam"

@interface NJADViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *launchImageView;
/********* 广告占位视图 *********/
@property (weak, nonatomic) IBOutlet UIView *ADContainerView;
@property (weak, nonatomic) IBOutlet UIButton *jumpBtn;
/********* 广告 *********/
@property(nonatomic,weak)UIImageView * adImageView;
/********* 广告数据模型 *********/
@property(nonatomic,strong)NJADItem * adItem;
/********* 定时器 *********/
@property(nonatomic,weak)NSTimer * timer;
- (IBAction)jumpBtnClick:(UIButton *)sender;

@end

@implementation NJADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置启动图片
    [self setupLaunchImage];
    // 加载广告数据 => 拿到活时间 => 服务器 => 查看接口文档 1.判断接口对不对 2.解析数据(w_picurl,ori_curl:跳转到广告界面,w,h) => 请求数据(AFN)
    //加载广告
    [self downloadAD];
    //设置定时器
    [self setupTimer];
}
#pragma mark - 设置定时器
- (void)setupTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
}
- (void)timeChange
{
    static int i = 3;
    i--;
    
    //改变跳转按钮文字
    if(i == 0)
    {
        [self jumpBtnClick:nil];
    }
    [self.jumpBtn setTitle:[NSString stringWithFormat:@"跳过 (%d)",i] forState:UIControlStateNormal];
    
}
#pragma mark - 懒加载
- (UIImageView *)adImageView
{
    if(_adImageView == nil)
    {
        UIImageView * imageView = [[UIImageView alloc]init];
        [self.ADContainerView addSubview:imageView];
        //设置广告的点击手势
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(adImageClick)];
        [self.ADContainerView addGestureRecognizer:tapGesture];
        //打开imageView的交互
        imageView.userInteractionEnabled = YES;
        _adImageView = imageView;
    }
    return _adImageView;
}
#pragma mark - 设置启动图片
- (void)setupLaunchImage
{
    // 6p:LaunchImage-800-Portrait-736h@3x.png
    // 6:LaunchImage-800-667h@2x.png
    // 5:LaunchImage-568h@2x.png
    // 4s:LaunchImage@2x.png
    if (iphone6P) { // 6p
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h@3x"];
    } else if (iphone6) { // 6
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-800-667h@2x"];
    } else if (iphone5) { // 5
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-568h@2x"];
        
    } else if (iphone4) { // 4
        
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-700@2x"];
    }
}
/*
 http://mobads.baidu.com/cpro/ui/mads.php? code2=
 phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam
 */
#pragma mark - 下载AD
- (void)downloadAD
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    //增加content-type: text/html
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];

    parameters[@"code2"] = code2;
    [manager GET:ADUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        [responseObject writeToFile:@"/Users/TouchWorld/ios/June_nine_BuDeJie(AD)/ad.plist" atomically:YES];
        NSArray * ads = responseObject[@"ad"];
        _adItem = [NJADItem mj_objectWithKeyValues:ads[0]];
        //设置占位视图frame
        CGFloat adImageViewH = NJScreenW / _adItem.w * _adItem.h;
        self.adImageView.frame = CGRectMake(0, 0, NJScreenW, adImageViewH);
        //加载广告图片
        NSURL * adUrl = [NSURL URLWithString:_adItem.w_picurl];
        [self.adImageView sd_setImageWithURL:adUrl];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (IBAction)jumpBtnClick:(UIButton *)jumpBtn
{
    //移除定时器
    [_timer invalidate];
    //销毁广告界面,显示主界面
    [UIApplication sharedApplication].keyWindow.rootViewController = [[NJTabBarController alloc]init];

}
#pragma mark - 点击广告图片
- (void)adImageClick
{
    UIApplication * app = [UIApplication sharedApplication];
    NSURL * adUrl = [NSURL URLWithString:_adItem.ori_curl];
    if([app canOpenURL:adUrl])
    {
        // The value of this key is an NSNumber object containing a Boolean value.
        NSDictionary * option = @{
                                  @"UIApplicationOpenURLOptionUniversalLinksOnly" : [NSNumber numberWithBool:NO],
                                  };
        [app openURL:adUrl options:option completionHandler:^(BOOL success) {
            
        }];
    }
}
@end
