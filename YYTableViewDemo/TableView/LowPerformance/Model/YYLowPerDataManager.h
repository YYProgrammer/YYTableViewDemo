//
//  YYLowPerDataManager.h
//  YYTableViewDemo
//
//  Created by yuyou on 2018/1/18.
//  Copyright © 2018年 yy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYLowPerDataManager : NSObject

/** 获取车辆数据 */
+ (void)getCarListDataWithBlock:(void(^)(NSArray *dataArray, NSError *error))block;

@end
