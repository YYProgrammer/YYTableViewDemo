//
//  YYLoadingView.m
//  B2CApp
//
//  Created by yuyou on 2017/12/15.
//  Copyright © 2017年 yy. All rights reserved.
//

#import "YYLoadingView.h"

@implementation YYLoadingView

+ (void)showInView:(UIView *)view beginY:(CGFloat)beginY withBackColor:(UIColor *)backColor
{
    //检查如果已经加过了就什么都不做
    for (UIView *childView in view.subviews)
    {
        if ([childView isKindOfClass:[YYLoadingView class]])
        {
            return;
        }
    }
    YYLoadingView *loadingView = [[YYLoadingView alloc] initWithView:view beginY:beginY backColor:backColor];
    [view addSubview:loadingView];
    [view bringSubviewToFront:loadingView];
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;//状态栏转圈
}

+ (void)removeFromView:(UIView *)view
{
    for (UIView *childView in view.subviews)
    {
        if ([childView isKindOfClass:[YYLoadingView class]])
        {
            [childView removeFromSuperview];
//            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;//状态栏停止转圈
            return;
        }
    }
}

- (instancetype)initWithView:(UIView *)view beginY:(CGFloat)beginY backColor:(UIColor *)backColor
{
    if (self = [super init])
    {
        self.backgroundColor = backColor;
        self.yy_width = 50;
        self.yy_height = 50;
        self.yy_centerX = view.yy_width * 0.5;
        self.yy_centerY = beginY + self.yy_height * 0.5;
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicator.center = CGPointMake(self.yy_width * 0.5, self.yy_height * 0.5);//只能设置中心，不能设置大小
        [self addSubview:activityIndicator];
        activityIndicator.color = UIColorFromRGB(0x666666); // 改变圈圈的颜色 iOS5引入
        [activityIndicator startAnimating]; // 开始旋转
    }
    return self;
}

@end
