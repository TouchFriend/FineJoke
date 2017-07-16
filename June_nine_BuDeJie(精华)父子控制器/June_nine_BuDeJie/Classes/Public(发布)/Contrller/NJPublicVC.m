//
//  NJPublicVC.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/10.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJPublicVC.h"
#import <pop/POP.h>
#import "NJPublicButton.h"

#define NJMaxColsCount 3 //最大列数
@interface NJPublicVC ()
/********* 按钮数组 *********/
@property(nonatomic,strong)NSMutableArray * buttons;
/********* 动画时间 *********/
@property(nonatomic,strong)NSArray * times;
/********* 标语 *********/
@property(nonatomic,strong)UIImageView * sloganView;
/********* 点击取消按钮 *********/
- (IBAction)cancelBtnClick:(UIButton *)sender;


@end
static CGFloat const NJSpringSpeed = 10;

@implementation NJPublicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //禁止交互
    self.view.userInteractionEnabled = NO;
    //设置按钮
    [self setupButtons];
    //设置标题
    [self setupSloganView];
}
#pragma mark - 懒加载
- (NSMutableArray *)buttons
{
    if(_buttons == nil)
    {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}
- (NSArray *)times
{
    if(_times == nil)
    {
        CGFloat interval = 0.1; // 时间间隔
        _times = @[@(5 * interval),
                   @(4 * interval),
                   @(3 * interval),
                   @(2 * interval),
                   @(0 * interval),
                   @(1 * interval),
                   @(6 * interval)]; // 也是标语的动画时间
    }
    return _times;
}
#pragma mark - 设置按钮
- (void)setupButtons
{
    // 数据
    NSArray *images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    NSArray *titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];
    // 一些参数
    NSUInteger count = images.count;
    NSUInteger rowsCount = (count + NJMaxColsCount - 1) / NJMaxColsCount;
    // 按钮尺寸
    CGFloat buttonW = NJScreenW / NJMaxColsCount;
    CGFloat buttonH = buttonW * 0.85;
    CGFloat buttonStartY = (NJScreenH - rowsCount * buttonH) * 0.5;
    for (int i = 0 ; i < count; i++) {
        NJPublicButton * btn = [NJPublicButton buttonWithType:UIButtonTypeCustom];
        btn.NJ_width = 0;
        //添加点击事件
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        //添加到按钮数组中
        [self.buttons addObject:btn];
        [self.view addSubview:btn];
        
        //设置内容
        
        [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];//设置图片
        [btn setTitle:titles[i] forState:UIControlStateNormal];//设置标题
        
        CGFloat buttonX = i % NJMaxColsCount * buttonW;
        CGFloat buttonY = buttonStartY + (i / NJMaxColsCount) * buttonH;
        
        //动画
        POPSpringAnimation * animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];//变化的是frame
        //从哪里开始
        animation.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonY - NJScreenH, buttonW, buttonH)];
        animation.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
        //设置动画速度
        animation.springSpeed = NJSpringSpeed;
        animation.springBounciness = NJSpringSpeed;
        //设置动画时间
        animation.beginTime = CACurrentMediaTime() + [self.times[i] doubleValue];
        //往按钮上添加动画
        [btn pop_addAnimation:animation forKey:nil];
    }
}
#pragma mark - 设置标语
- (void)setupSloganView
{
    CGFloat sloganY = NJScreenH * 0.2;
    
    // 添加
    UIImageView *sloganView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    sloganView.NJ_y = sloganY - NJScreenH;
    sloganView.NJ_centerX = NJScreenW * 0.5;
    [self.view addSubview:sloganView];
    self.sloganView = sloganView;
    
    NJWeakSelf //定义弱引用
    // 动画
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anim.toValue = @(sloganY);
    anim.springSpeed = NJSpringSpeed;
    anim.springBounciness = NJSpringSpeed;
    // CACurrentMediaTime()获得的是当前时间
    anim.beginTime = CACurrentMediaTime() + [self.times.lastObject doubleValue];
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        // 开始交互
        weakSelf.view.userInteractionEnabled = YES;
    }];
    [sloganView.layer pop_addAnimation:anim forKey:nil];

}
#pragma mark - 退出动画
- (void)exit:(void (^)())task
{
    // 禁止交互
    self.view.userInteractionEnabled = NO;
    
    // 让按钮执行动画
    for (int i = 0; i < self.buttons.count; i++) {
        NJPublicButton *button = self.buttons[i];
        
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        anim.toValue = @(button.layer.position.y + NJScreenH);
        // CACurrentMediaTime()获得的是当前时间
        anim.beginTime = CACurrentMediaTime() + [self.times[i] doubleValue];
        [button.layer pop_addAnimation:anim forKey:nil];
    }
    
    NJWeakSelf;
    // 让标题执行动画
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anim.toValue = @(self.sloganView.layer.position.y + NJScreenH);
    // CACurrentMediaTime()获得的是当前时间
    anim.beginTime = CACurrentMediaTime() + [self.times.lastObject doubleValue];
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
        
        // 可能会做其他事情
        //        if (task) task();
        !task ? : task();
    }];
    [self.sloganView.layer pop_addAnimation:anim forKey:nil];
}
- (void)btnClick:(UIButton *)button
{
//    NJLog(@"%s",__func__);
    //退出界面，并实现按钮功能
    [self exit:^{
        //取出按钮索引
        NSUInteger index = [self.buttons indexOfObject:button];
        switch (index) {
            case 2: { // 发段子
                NJLog(@"发段子");
                break;
            }
                
            case 0:
                NJLog(@"发视频");
                break;
                
            case 1:
                NJLog(@"发图片");
                break;
            case 3:
                NJLog(@"发声音");
                break;

            case 4:
                NJLog(@"审帖");
                break;

            case 5:
                NJLog(@"离线下载");
                break;
            default:
                NJLog(@"其他");
                break;
        }

    }];
}
#pragma mark - 点击取消按钮
- (IBAction)cancelBtnClick:(UIButton *)sender
{
    [self exit:nil];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self exit:nil];
}
@end
