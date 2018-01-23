//
//  YYLowPerTableViewCell.h
//  bjesc
//
//  Created by yuyou on 2017/9/5.
//  Copyright © 2017年 bjjd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYLowPerCarModel;

@interface YYLowPerTableViewCell : UITableViewCell

//模型
@property (nonatomic,strong) YYLowPerCarModel *model;

//创建cell快捷方式
+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)getCellHeight;

@end
