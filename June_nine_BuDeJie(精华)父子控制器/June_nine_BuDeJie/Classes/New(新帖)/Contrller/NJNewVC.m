//
//  NJNewVC.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/10.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJNewVC.h"
#import "NJSubTagsVC.h"
@interface NJNewVC ()

@end

@implementation NJNewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor brownColor];
    [self setupNavBar];
}
#pragma mark - 设置导航条
- (void)setupNavBar
{
    //左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithNormalImage:[UIImage imageNamed:@"MainTagSubIcon"] highLightImage:[UIImage imageNamed:@"MainTagSubIconClick"] target:self action:@selector(tagSubBtnClick)];
    //中间标题
//    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainTitle"]];
    self.title = @"新帖";
}
- (void)tagSubBtnClick
{
    //跳转到订阅标签界面
    NJSubTagsVC * subTagsVC = [[NJSubTagsVC alloc]init];
    [self.navigationController pushViewController:subTagsVC animated:YES];
    
}
@end
