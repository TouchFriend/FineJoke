//
//  NJFriendTrendVC.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/10.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJFriendTrendVC.h"
#import "NJLoginRegisterVC.h"
@interface NJFriendTrendVC ()
- (IBAction)loginRegisterBtnClick:(UIButton *)sender;
@end

@implementation NJFriendTrendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavBar];
    
}
#pragma mark - 设置导航条
- (void)setupNavBar
{
    //左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithNormalImage:[UIImage imageNamed:@"friendsRecommentIcon"] highLightImage:[UIImage imageNamed:@"friendsRecommentIcon-click"] target:self action:@selector(friendBtnClick)];
    //中间标题
    self.navigationItem.title = @"我的关注";
}
- (void)friendBtnClick
{
    NJFunc;
}


- (IBAction)loginRegisterBtnClick:(UIButton *)sender
{
    //跳转到登录注册界面
    NJLoginRegisterVC * loginRegisterVC = [[NJLoginRegisterVC alloc]init];
    [self presentViewController:loginRegisterVC animated:YES completion:^{
        
    }];
}
@end
