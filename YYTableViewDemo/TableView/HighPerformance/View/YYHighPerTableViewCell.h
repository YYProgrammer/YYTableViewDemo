//
//  YYHighPerTableViewCell.h
//  YYTableViewDemo
//
//  Created by yuyou on 2018/1/18.
//  Copyright © 2018年 yy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYHighPerCarModel;

@interface YYHighPerTableViewCell : UITableViewCell

//模型
@property (nonatomic,strong) YYHighPerCarModel *model;

//创建cell快捷方式
+ (instancetype)cellWithTableView:(UITableView *)tableView;
//行高
+ (CGFloat)getCellHeight;

@end
