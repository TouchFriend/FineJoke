//
//  NJVoiceVC.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/19.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJVoiceVC.h"

@interface NJVoiceVC ()

@end

@implementation NJVoiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = NJRandomColor;
    
    
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

@end
