//
//  YYLoadingView.h
//  B2CApp
//
//  Created by yuyou on 2017/12/15.
//  Copyright © 2017年 yy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYLoadingView : UIView

+ (void)showInView:(UIView *)view beginY:(CGFloat)beginY withBackColor:(UIColor *)backColor;

+ (void)removeFromView:(UIView *)view;

@end
