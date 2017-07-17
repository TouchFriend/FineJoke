//
//  NJLauncheViewController.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/7/17.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJLauncheViewController.h"
#import "NJLaunchView.h"

@interface NJLauncheViewController ()

@end

@implementation NJLauncheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [NJLaunchView addLaunchView];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
