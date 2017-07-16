//
//  NJPlayerViewController.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/7/14.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJPlayerViewController.h"
#import "NJTopic.h"
#import <ZFPlayer/ZFPlayer.h>

@interface NJPlayerViewController () <ZFPlayerDelegate>
@property (nonatomic, strong) UIView *playerFatherView;
@property (nonatomic, strong) ZFPlayerView *playerView;
@property (nonatomic, strong) ZFPlayerModel *playerModel;
@end

@implementation NJPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addFatherView];
    [self addPlayerView];
    [self addPlayerModel];
    self.playerView.delegate = self;
    [self.playerView autoPlayTheVideo];
}
- (void)addFatherView
{
    self.playerFatherView = [[UIView alloc] init];
    [self.view addSubview:self.playerFatherView];
    [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.leading.trailing.mas_equalTo(0);
//         这里宽高比16：9,可自定义宽高比
        make.height.mas_equalTo(self.playerFatherView.mas_width).multipliedBy(9.0f/16.0f);
    }];
}
- (void)addPlayerView
{
    self.playerView = [[ZFPlayerView alloc] init];
    [self.view addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.right.equalTo(self.view);
        // 这里宽高比16：9，可以自定义视频宽高比
        make.height.equalTo(self.playerView.mas_width).multipliedBy(9.0f/16.0f);
    }];
}
- (void)addPlayerModel
{
    ZFPlayerControlView * controlView = [[ZFPlayerControlView alloc]init];
    ZFPlayerModel * playerModle = [[ZFPlayerModel alloc]init];
    playerModle.videoURL = [NSURL URLWithString:self.topic.videouri];

    playerModle.title = self.topic.text;
    playerModle.fatherView = self.playerFatherView;
    [self.playerView playerControlView:controlView playerModel:playerModle];
}
- (void)zf_playerBackAction
{
   [self dismissViewControllerAnimated:YES completion:nil];
}
@end
