//
//  NJPictureVC.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/19.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJPictureVC.h"

@interface NJPictureVC ()

@end

@implementation NJPictureVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = NJRandomColor;
    self.tableView.contentInset = UIEdgeInsetsMake(NJNavBarMaxY + NJTitleBarHeight, 0, NJTabBarHeight, 0);
    //监听TabBarButton被重复点击的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidRepeatClick) name:NJTabBarButtonDidRepeatClickNotification object:nil];
    //监听标题栏按钮的点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleBarButtonDidRepeatClick) name:NJTitleBarButtonDidRepeatClickNotification object:nil];
    //设置滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
}
#pragma mark - 标题栏按钮被点击
- (void)titleBarButtonDidRepeatClick
{
    [self tabBarButtonDidRepeatClick];
}
#pragma mark - 精华TabBarButton被重复点击
- (void)tabBarButtonDidRepeatClick
{
    //1.判断是否是精华被重复点击(tabBarController是暂时隐藏上一个控制器，显示被点击的tabBarButton对应的子控制器，所以可以通过window是否有值来判断)
    if(!self.view.window)
    {
        return;
    }
    //2.判断全部子控制器的view在正中间(只有正中间view的scrollsToTop是YES)
    if(!self.tableView.scrollsToTop)
    {
        return;
    }
    NJFunc;
}
#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@-%zd", self.class, indexPath.row];
    return cell;
}
#pragma mark - dealloc
- (void)dealloc
{
    //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
