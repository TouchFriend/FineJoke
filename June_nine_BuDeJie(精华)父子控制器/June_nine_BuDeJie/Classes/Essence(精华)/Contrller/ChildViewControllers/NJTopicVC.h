//
//  NJTopicVC.h
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/7/12.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJTopic.h"
@interface NJTopicVC : UITableViewController
//获取数据的类型,默认是（全部）
- (NJTopicType)type;
@end
