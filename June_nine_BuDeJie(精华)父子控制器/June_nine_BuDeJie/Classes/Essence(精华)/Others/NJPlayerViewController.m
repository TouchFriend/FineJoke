//
//  NJPlayerViewController.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/7/14.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJPlayerViewController.h"
#import "NJTopic.h"

@interface NJPlayerViewController ()
/********** 点击返回按钮 **********/
- (IBAction)backBtnClick:(UIButton *)sender;
/********* 播放器 *********/
@property(nonatomic,strong)AVPlayer * player;
/********* 播放器层 *********/
@property(nonatomic,strong)AVPlayerLayer * playerLayer;
/********* 播放器单元 *********/
@property(nonatomic,strong)AVPlayerItem * playerItem;
/********* 用户存储avPlayerLayer *********/
@property (weak, nonatomic) IBOutlet UIView *playerView;

@end

@implementation NJPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.topic.videouri]];
    //创建播放器
    self.player = [[AVPlayer alloc]initWithPlayerItem:self.playerItem];
    //创建播放图层
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    //往播放占位视图上添加播放图层
    [self.playerView.layer addSublayer:self.playerLayer];
    
}
- (void)viewDidLayoutSubviews
{
    self.playerLayer.frame = self.playerView.bounds;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.player play];
}

- (IBAction)backBtnClick:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
