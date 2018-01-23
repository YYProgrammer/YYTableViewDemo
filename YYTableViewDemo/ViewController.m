//
//  ViewController.m
//  YYTableViewDemo
//
//  Created by yuyou on 2018/1/18.
//  Copyright © 2018年 yy. All rights reserved.
//

#import "ViewController.h"
#import "YYLowPerViewController.h"
#import "YYHighPerViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.extendedLayoutIncludesOpaqueBars = YES;//从顶部开始布局
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    [self.view addSubview:tipLabel];
    tipLabel.textAlignment = NSTextAlignmentLeft;
    tipLabel.font = [UIFont systemFontOfSize:16];
    tipLabel.textColor = [UIColor blackColor];
    tipLabel.frame = CGRectMake(15, NAVBAR_HEIGHT + STATUS_HEIGHT, kMainScreenWidth - 15 * 2, 150);
    tipLabel.numberOfLines = 0;
    tipLabel.text = @"1、请使用真机调试来观察流畅性；\n\n2、低性能版，滑动tableview，松开手指让其自由减速，在减速过程中，会出现明显的掉帧，越老的手机越明显。";
    
    UIButton *lowButton = [[UIButton alloc] init];
    [self.view addSubview:lowButton];
    lowButton.frame = CGRectMake(15, kMainScreenHeight - SYSTEM_GESTURE_HEIGHT - 15 - 50, (kMainScreenWidth - 3 * 15) * 0.5, 50);
    [lowButton setTitle:@"低性能版" forState:UIControlStateNormal];
    [lowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lowButton setBackgroundColor:[UIColor blueColor]];
    [lowButton addTarget:self action:@selector(clickLowButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *highButton = [[UIButton alloc] init];
    [self.view addSubview:highButton];
    highButton.frame = CGRectMake(CGRectGetMaxX(lowButton.frame) + 15, lowButton.yy_y, lowButton.yy_width, lowButton.yy_height);
    [highButton setTitle:@"高性能版" forState:UIControlStateNormal];
    [highButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [highButton setBackgroundColor:[UIColor blueColor]];
    [highButton addTarget:self action:@selector(clickHighButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickLowButton
{
    YYLowPerViewController *low = [[YYLowPerViewController alloc] init];
    [self.navigationController pushViewController:low animated:YES];
}

- (void)clickHighButton
{
    YYHighPerViewController *high = [[YYHighPerViewController alloc] init];
    [self.navigationController pushViewController:high animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
