//
//  YYLowPerDataManager.m
//  YYTableViewDemo
//
//  Created by yuyou on 2018/1/18.
//  Copyright © 2018年 yy. All rights reserved.
//

#import "YYLowPerDataManager.h"
#import "YYLowPerCarModel.h"
#import "NSObject+YYModel.h"

@implementation YYLowPerDataManager

/** 获取车辆数据 */
+ (void)getCarListDataWithBlock:(void(^)(NSArray *dataArray, NSError *error))block
{
    //放入异步线程做
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 获取文件路径
        NSString *path = [[NSBundle mainBundle] pathForResource:@"carList.json" ofType:@""];
        // 将文件数据化
        NSData *data = [NSData dataWithContentsOfFile:path];
        // 对数据进行JSON格式化并返回字典形式
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *dataArray = [NSArray modelArrayWithClass:[YYLowPerCarModel class] json:jsonDict[@"data"]];
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            block(dataArray, nil);
        });
    });
}

@end
