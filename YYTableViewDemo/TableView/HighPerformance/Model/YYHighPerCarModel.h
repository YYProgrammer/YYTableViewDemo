//
//  YYHighPerCarModel.h
//  bjesc
//
//  Created by yuyou on 2017/9/5.
//  Copyright © 2017年 bjjd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YYTextLayout;
@class YYWebImageManager;

/** 小图cell */
#define CAR_VERSION_LABEL_WIDTH (kMainScreenWidth - 15 - 120 - 10 - 15)
#define CAR_VERSION_LABEL_FONT ([UIFont fontWithName:MAIN_CELL_TITLE_FONT_NAME size:15])
#define CAR_DESCRIBE_LABEL_SMALL_CELL_TEXT_COLOR UIColorFromRGB(0x979797)
#define CAR_DESCRIBE_LABEL_FONT [UIFont systemFontOfSize:11]
#define CAR_DESCRIBE_LABEL_HEIGHT 15.0
#define CAR_PRICE_LABEL_HEIGHT 20.0
#define CAR_PRICE_FRONT_LABEL_FONT [UIFont systemFontOfSize:16]
#define CAR_PRICE_BEHIND_LABEL_FONT [UIFont systemFontOfSize:13]

@interface YYHighPerCarModel : NSObject

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
@property (nonatomic,assign) int isEnddown;//是否已下架（默认为0否)

/** 布局用到的参数 */
@property (nonatomic,assign) CGFloat carVersionLabelHeight;//车型label的高
@property (nonatomic,strong) YYTextLayout *carVersionLabelLayout;//车型的layout
@property (nonatomic,strong) YYTextLayout *carDescribeLabelLayout;//车辆描述的layout
@property (nonatomic,strong) YYTextLayout *carPriceLabelLayout;//车价全款layout

//初始化供view用的那些参数
- (void)setupViewModel;
//车图片圆角处理
+ (YYWebImageManager *)avatarImageManager;
//车圆角占位图
+ (UIImage *)sharedPlaceHolderImage;

@end

