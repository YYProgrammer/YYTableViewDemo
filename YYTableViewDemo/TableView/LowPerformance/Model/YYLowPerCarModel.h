//
//  YYLowPerCarModel.h
//  bjesc
//
//  Created by yuyou on 2017/9/5.
//  Copyright © 2017年 bjjd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YYLowPerCarModel : NSObject

@property (nonatomic,strong) NSString *checkCityName;//车源城市名
@property (nonatomic,strong) NSString *carId;//车源ID
@property (nonatomic,strong) NSString *imgUrl;//封面图片url
@property (nonatomic,strong) NSString *carName;//车源标题
@property (nonatomic,strong) NSString *licenseTime;//时间
@property (nonatomic,strong) NSString *travelMileage;//行驶里程 单位万公里
@property (nonatomic,strong) NSString *ownerPrice;//全款金额
@property (nonatomic,strong) NSString *firstPrice;//首付金额
@property (nonatomic,strong) NSString *publishNew;//是否是新车（10天内上架） 是则返回1 否则返回空字符
@property (nonatomic,strong) NSString *poor;//降价幅度 若存在降价幅度则返回价格字符，否则返回空字符串
@property (nonatomic,assign) int isEnddown;//是否已下架（默认为0否）


@end
