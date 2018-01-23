//
//  YYHighPerCarModel.m
//  bjesc
//
//  Created by yuyou on 2017/9/5.
//  Copyright © 2017年 bjjd. All rights reserved.
//

#import "YYHighPerCarModel.h"
#import "YYKit.h"

@implementation YYHighPerCarModel

//初始化供view用的一些参数
- (void)setupViewModel
{
    //车型布局参数
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:self.carName];
    text.color = BLACK_TEXT_COLOR;
    text.font = CAR_VERSION_LABEL_FONT;
    text.lineSpacing = -4;
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(CAR_VERSION_LABEL_WIDTH, MAXFLOAT)];
    self.carVersionLabelLayout = [YYTextLayout layoutWithContainer:container text:text];
    self.carVersionLabelHeight = 0 + 0 + CAR_VERSION_LABEL_FONT.pointSize * 0.86 + CAR_VERSION_LABEL_FONT.pointSize * 0.14 + (self.carVersionLabelLayout.rowCount - 1) * (CAR_VERSION_LABEL_FONT.pointSize * 1.34);//这个算法来自YYLabel
    //    self.carVersionLabelHeight = self.carVersionLabelLayout.textBoundingSize.height;//利用这种方法也可以获取高度，但是有上下边距。
    
    //车辆描述布局参数
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    [formatter setDateFormat:@"yyyy年MM月"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[self.licenseTime intValue]];
    NSString* licenseTime_showString = [formatter stringFromDate:date];
    NSString *travelMileage_showString = (self.travelMileage != nil && ![self.travelMileage isEqualToString:@""]) ? [NSString stringWithFormat:@"%@万公里",self.travelMileage] : @"里程暂无";
    NSString  *carDescribeLabel_showString = [NSString stringWithFormat:@"%@ / %@",licenseTime_showString,travelMileage_showString];
    NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:carDescribeLabel_showString];
    text1.color = CAR_DESCRIBE_LABEL_SMALL_CELL_TEXT_COLOR;
    text1.font = CAR_DESCRIBE_LABEL_FONT;
    YYTextContainer *container1 = [YYTextContainer containerWithSize:CGSizeMake(CAR_VERSION_LABEL_WIDTH, CAR_DESCRIBE_LABEL_HEIGHT)];
    self.carDescribeLabelLayout = [YYTextLayout layoutWithContainer:container1 text:text1];
    
    //车价布局参数
    NSString *carPriceFrontLabel_notLoan_showString = [NSString stringWithFormat:@"%@万",self.ownerPrice];
    NSString *carPriceBehindLabel_notLoan_showString = (self.firstPrice != nil && ![self.firstPrice isEqualToString:@""]) ? [NSString stringWithFormat:@"首付%@万",self.firstPrice] : @"";
    NSString *carPriceString = [NSString stringWithFormat:@"%@ %@", carPriceFrontLabel_notLoan_showString, carPriceBehindLabel_notLoan_showString];
    NSMutableAttributedString *text3 = [[NSMutableAttributedString alloc] initWithString:carPriceString];
    text3.color = ORANGE_TEXT_COLOR;
    text3.font = CAR_PRICE_BEHIND_LABEL_FONT;
    [text3 addAttribute:NSFontAttributeName value:CAR_PRICE_FRONT_LABEL_FONT range:NSMakeRange(0, carPriceFrontLabel_notLoan_showString.length)];
    YYTextContainer *container2 = [YYTextContainer containerWithSize:CGSizeMake(CAR_VERSION_LABEL_WIDTH, CAR_PRICE_LABEL_HEIGHT)];
    self.carPriceLabelLayout = [YYTextLayout layoutWithContainer:container2 text:text3];
}

+ (YYWebImageManager *)avatarImageManager
{
    static YYWebImageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[UIApplication sharedApplication].cachesPath stringByAppendingPathComponent:@"carList.carImage"];
        YYImageCache *cache = [[YYImageCache alloc] initWithPath:path];
        manager = [[YYWebImageManager alloc] initWithCache:cache queue:[YYWebImageManager sharedManager].queue];
        manager.sharedTransformBlock = ^(UIImage *image, NSURL *url){
            if (!image) return image;
            return [image imageByRoundCornerRadius:(image.size.width * 0.05)]; // a large value
        };
    });
    return manager;
}

//车圆角占位图
+ (UIImage *)sharedPlaceHolderImage
{
    static dispatch_once_t onceToken;
    static UIImage *sharedPlaceHolderImage = nil;
    dispatch_once(&onceToken, ^{
        if (!sharedPlaceHolderImage)
        {
            UIImage *image = [UIImage imageNamed:@"bigPlaceHolder.png"];
            sharedPlaceHolderImage = [image imageByRoundCornerRadius:image.size.width * 0.05];
        }
    });
    return sharedPlaceHolderImage;
}

@end

