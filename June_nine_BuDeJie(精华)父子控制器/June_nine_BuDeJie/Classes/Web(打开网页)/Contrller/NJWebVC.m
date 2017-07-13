//
//  NJWebVC.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/16.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJWebVC.h"
#import <WebKit/WebKit.h>
@interface NJWebVC ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
/********* webView *********/
@property(nonatomic,weak)WKWebView * webView;
- (IBAction)goBackBtnClick:(UIBarButtonItem *)sender;
- (IBAction)goForwardBtnClick:(UIBarButtonItem *)sender;
- (IBAction)refreshBtnClick:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBackbtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForwardBtn;
@property (weak, nonatomic) IBOutlet UIProgressView *loadProgressView;
@end

@implementation NJWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //设置webView
    [self setupWebView];
}
- (void)setupWebView
{
    WKWebView * webView = [[WKWebView alloc]init];
    _webView = webView;
    [self.containerView addSubview:webView];
    //加载网页
    NSURLRequest * request = [NSURLRequest requestWithURL:self.url];
    [webView loadRequest:request];
    //添加监听器,当页面前进后退时，canGoBack值肯定改变
    //监听canGoBack值得改变
    [webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    //监听canGoForward值得改变
    [webView addObserver:self forKeyPath:@"canGoForward" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    //监听title值得改变
    [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    //监听进度条的改变
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}
//设置子控件的frame
- (void)viewDidLayoutSubviews
{
    _webView.frame = self.containerView.bounds;
}

- (IBAction)goBackBtnClick:(UIBarButtonItem *)sender
{
    [_webView goBack];
}

- (IBAction)goForwardBtnClick:(UIBarButtonItem *)sender
{
    [_webView goForward];
}

- (IBAction)refreshBtnClick:(UIBarButtonItem *)sender
{
    [_webView reload];
}
#pragma mark - 监听值得改变

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    self.title = [self.webView title];
    self.goBackbtn.enabled = [self.webView canGoBack];
    self.goForwardBtn.enabled = [self.webView canGoForward];
    self.loadProgressView.progress = self.webView.estimatedProgress;
    //隐藏进度条
    
    self.loadProgressView.hidden = self.webView.estimatedProgress >= 1;
}


- (void)dealloc
{
    //移除监听者
    //dealloc最好不用self，因为getter方法可能造成循环引用
    [_webView removeObserver:self forKeyPath:@"canGoBack"];
    [_webView removeObserver:self forKeyPath:@"canGoForward"];
    [_webView removeObserver:self forKeyPath:@"title"];
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    
}
@end
