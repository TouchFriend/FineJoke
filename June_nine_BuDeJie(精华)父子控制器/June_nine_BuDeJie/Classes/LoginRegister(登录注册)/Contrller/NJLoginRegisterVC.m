//
//  NJLoginRegisterVC.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/14.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJLoginRegisterVC.h"
#import "NJLoginRegisterView.h"
#import "NJFastLoginView.h"

@interface NJLoginRegisterVC ()
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleLeadingConstraint;

- (IBAction)backBtnClick:(UIButton *)sender;
- (IBAction)switchBtnClick:(UIButton *)sender;


@end

@implementation NJLoginRegisterVC
// 越复杂的界面 越要封装(复用)
/*
 屏幕适配:
 1.一个view从xib加载,需不需在重新固定尺寸 一定要在重新设置一下
 
 2.在viewDidLoad设置控件frame好不好,开发中一般在viewDidLayoutSubviews布局子控件
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    //1.添加登录view
    NJLoginRegisterView * loginView = [NJLoginRegisterView loginView];
    [self.middleView addSubview:loginView];
    //2.添加注册view
    NJLoginRegisterView * registerView = [NJLoginRegisterView registerView];
    [self.middleView addSubview:registerView];
    //3.添加快速登录
    NJFastLoginView * fastLoginView = [NJFastLoginView fastLoginView];
    [self.bottomView addSubview:fastLoginView];
}
// viewDidLayoutSubviews:才会根据布局调整控件的尺寸
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //1.设置loginView的frame
    NJLoginRegisterView * loginView = self.middleView.subviews[0];
    loginView.frame = CGRectMake(0, 0, self.middleView.NJ_width * 0.5, self.middleView.NJ_height);
    //2.设置registerView的frame
    NJLoginRegisterView * registerView = self.middleView.subviews[1];
        registerView.frame = CGRectMake(self.middleView.NJ_width * 0.5, 0, self.middleView.NJ_width * 0.5, self.middleView.NJ_height);
    //3.设置fastLoginView的frame
    NJFastLoginView * fastLoginView = self.bottomView.subviews[0];
    //不能用frame，因为frame是相对于父类计算的
    fastLoginView.bounds = self.bottomView.bounds;
    
}

- (IBAction)backBtnClick:(UIButton *)backBtn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)switchBtnClick:(UIButton *)switchBtn
{
    switchBtn.selected = !switchBtn.selected;
    //通过约束改变middleView的位置
    
    self.middleLeadingConstraint.constant = self.middleLeadingConstraint.constant == 0 ? ( -self.middleView.NJ_width * 0.5) : 0;
    //动画
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}
@end
