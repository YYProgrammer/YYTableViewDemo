//
//  YYLowPerTableViewCell.m
//  bjesc
//
//  Created by yuyou on 2017/9/5.
//  Copyright © 2017年 bjjd. All rights reserved.
//

#import "YYLowPerTableViewCell.h"
#import "YYLowPerCarModel.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

#define TIP_IMAGE_WIDTH 40.0
#define NEW_CAR_IMAGE_WIDTH 38
#define TIP_IMAGE_TOP_OFFSET_PROPORTION (5.0 / 62.0)

@interface YYLowPerTableViewCell ()

@property (nonatomic,strong) UIImageView *carImageView;//展示图
@property (nonatomic,strong) UIImageView *carDepreciateTip;//降价标签
@property (nonatomic,strong) UILabel *carDepreciateLabel;//降价金额
@property (nonatomic,strong) UIImageView *carNewTip;//新上标签
@property (nonatomic,strong) UILabel *carVersionLabel;//车型
@property (nonatomic,strong) UILabel *carDescribeLabel;//车型
@property (nonatomic,strong) UILabel *carPriceFrontLabel;//价格(大字)
@property (nonatomic,strong) UILabel *carPriceBehindLabel;//价格(小字)
@property (nonatomic,strong) UIView *separatorLine;//分割线
@property (nonatomic,strong) UILabel *fixedLabel;//已降文字label
@property (nonatomic,strong) UILabel *isEnddownLabel;//下架文字标签

@end

@implementation YYLowPerTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"YYLowPerTableViewCell";
    
    YYLowPerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[YYLowPerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

+ (CGFloat)getCellHeight
{
    return 15.0 + 80 + 15 + 1;
}


- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat carVersionLabelWidth = kMainScreenWidth - 15 - 120 - 10 - 15;
    
    CGFloat carVersionLabelHeight = [self.model.carName boundingRectWithSize:CGSizeMake(carVersionLabelWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont fontWithName:MAIN_CELL_TITLE_FONT_NAME size:15]} context:nil].size.height + 0.5;
    if (carVersionLabelHeight > 37.79)//两行的高度,超过按两行处理
    {
        carVersionLabelHeight = 37.79;
    }
    
    [self.carImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(90);
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(15);
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(10);
    }];

    [self.carDepreciateTip mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.carImageView);
        make.top.mas_equalTo(self.carImageView).mas_offset(-TIP_IMAGE_TOP_OFFSET_PROPORTION * (TIP_IMAGE_WIDTH * 62 / 68));
        make.width.mas_equalTo(TIP_IMAGE_WIDTH);
        make.height.mas_equalTo(TIP_IMAGE_WIDTH * 62 / 68);
    }];
    
    [self.carNewTip mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.carImageView);
        make.width.mas_equalTo(NEW_CAR_IMAGE_WIDTH);
        make.height.mas_equalTo(NEW_CAR_IMAGE_WIDTH * 26 / 78);
    }];
    
    if (carVersionLabelHeight > 30)//15号字体下，大于30的高必定是2行
    {
        [self.carVersionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.carImageView.mas_right).mas_offset(10);
            make.top.mas_equalTo(self.carImageView.mas_top).mas_offset(-2);
            make.height.mas_equalTo(carVersionLabelHeight);
            make.width.mas_equalTo(carVersionLabelWidth);
        }];
        
        [self.carDescribeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.carVersionLabel.mas_left);
            make.centerY.mas_equalTo(self.carImageView).mas_offset(9.5);
        }];
    }
    else
    {
        [self.carVersionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.carImageView.mas_right).mas_offset(10);
            make.top.mas_equalTo(self.carImageView.mas_top).mas_offset(0);
            make.height.mas_equalTo(carVersionLabelHeight);
            make.width.mas_equalTo(carVersionLabelWidth);
        }];
        
        [self.carDescribeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.carVersionLabel.mas_left);
            make.centerY.mas_equalTo(self.carImageView);
        }];
    }
    
    [self.carPriceFrontLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.carVersionLabel.mas_left);
        make.bottom.mas_equalTo(self.carImageView.mas_bottom).mas_offset(3);
    }];
    
    [self.carPriceBehindLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.carPriceFrontLabel.mas_right).mas_offset(4);
        make.bottom.mas_equalTo(self.carImageView.mas_bottom).mas_offset(2);
    }];
    
    [self.separatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(15);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(1);
    }];

    [self.isEnddownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(self.carImageView);
    }];
}

- (void)setModel:(YYLowPerCarModel *)model
{
    _model = model;

    //赋值
    if (model.imgUrl != nil && ![model.imgUrl isEqualToString:@""])
    {
        [self.carImageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"bigPlaceHolder.png"] options:SDWebImageRetryFailed];
    }
    else
    {
        self.carImageView.image = [UIImage imageNamed:@"bigPlaceHolder.png"];
    }
    
    
    if ([model.publishNew isEqualToString:@"1"])//新上
    {
        self.carDepreciateTip.hidden = YES;
        self.carNewTip.hidden = NO;
    }
    else if ((model.poor != nil) && (![model.poor isEqualToString:@""]))
    {
        self.carDepreciateTip.hidden = NO;
        self.carNewTip.hidden = YES;
        self.carDepreciateLabel.text = [NSString stringWithFormat:@"%@",model.poor];
    }
    else
    {
        self.carDepreciateTip.hidden = YES;
        self.carNewTip.hidden = YES;
    }
    
    self.carVersionLabel.text = model.carName;
    
    //上牌时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    [formatter setDateFormat:@"yyyy年MM月"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[model.licenseTime intValue]];
    NSString* licenseTimeString = [formatter stringFromDate:date];
    //里程
    NSString *travelMileageString = (model.travelMileage != nil && ![model.travelMileage isEqualToString:@""]) ? [NSString stringWithFormat:@"%@万公里",model.travelMileage] : @"里程暂无";
    self.carDescribeLabel.text = [NSString stringWithFormat:@"%@ / %@",licenseTimeString,travelMileageString];
    
    //价格
    self.carPriceFrontLabel.text = [NSString stringWithFormat:@"%@万",model.ownerPrice];
    self.carPriceBehindLabel.text = (model.firstPrice != nil && ![model.firstPrice isEqualToString:@""]) ? [NSString stringWithFormat:@"首付%@万",model.firstPrice] : @"";
    
    self.isEnddownLabel.hidden = !(model.isEnddown == 1);
}

#pragma mark - 懒加载
- (UIImageView *)carImageView
{
    if (!_carImageView)
    {
        _carImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_carImageView];
        _carImageView.contentMode = UIViewContentModeScaleAspectFill;
        _carImageView.layer.cornerRadius = 8.0;
        _carImageView.layer.masksToBounds = YES;
    }
    return _carImageView;
}

- (UIImageView *)carDepreciateTip
{
    if (!_carDepreciateTip)
    {
        _carDepreciateTip = [[UIImageView alloc] init];
        [self.contentView addSubview:_carDepreciateTip];
        _carDepreciateTip.hidden = YES;
        _carDepreciateTip.image = [UIImage imageNamed:@"depreciateTip.png"];
        _carDepreciateTip.contentMode = UIViewContentModeScaleToFill;
        
        UILabel *fixedWord = [[UILabel alloc] init];
        [_carDepreciateTip addSubview:fixedWord];
        self.fixedLabel = fixedWord;
        fixedWord.font = [UIFont systemFontOfSize:9];
        fixedWord.textColor = [UIColor whiteColor];
        fixedWord.text = @"已降";
        [fixedWord sizeToFit];
        [fixedWord mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_carDepreciateTip.mas_centerX);
            make.top.mas_equalTo(_carDepreciateTip.mas_top).mas_offset(5);
        }];
        
        self.carDepreciateLabel = [[UILabel alloc] init];
        [_carDepreciateTip addSubview:self.carDepreciateLabel];
        self.carDepreciateLabel.font = [UIFont systemFontOfSize:9];
        self.carDepreciateLabel.textColor = [UIColor whiteColor];
        [self.carDepreciateLabel sizeToFit];
        [self.carDepreciateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_carDepreciateTip.mas_centerX);
            make.top.mas_equalTo(fixedWord.mas_bottom).mas_offset(-0.5);
        }];
    }
    return _carDepreciateTip;
}

- (UIImageView *)carNewTip
{
    if (!_carNewTip)
    {
        _carNewTip = [[UIImageView alloc] init];
        [self.contentView addSubview:_carNewTip];
        _carNewTip.hidden = YES;
        _carNewTip.image = [UIImage imageNamed:@"newTip.png"];
        _carNewTip.contentMode = UIViewContentModeScaleToFill;
    }
    return _carNewTip;
}

- (UILabel *)carVersionLabel
{
    if (!_carVersionLabel)
    {
        _carVersionLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_carVersionLabel];
        _carVersionLabel.backgroundColor = self.contentView.backgroundColor;
        _carVersionLabel.font = [UIFont fontWithName:MAIN_CELL_TITLE_FONT_NAME size:15];
        _carVersionLabel.textColor = BLACK_TEXT_COLOR;
        _carVersionLabel.numberOfLines = 0;
        _carVersionLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _carVersionLabel;
}

- (UILabel *)carDescribeLabel
{
    if (!_carDescribeLabel)
    {
        _carDescribeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_carDescribeLabel];
        _carDescribeLabel.backgroundColor = self.contentView.backgroundColor;
        _carDescribeLabel.font = [UIFont systemFontOfSize:10];
        _carDescribeLabel.textColor = UIColorFromRGB(0x979797);
        _carDescribeLabel.numberOfLines = 0;
        [_carDescribeLabel sizeToFit];
    }
    return _carDescribeLabel;
}

- (UILabel *)carPriceFrontLabel
{
    if (!_carPriceFrontLabel)
    {
        _carPriceFrontLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_carPriceFrontLabel];
        _carPriceFrontLabel.backgroundColor = self.contentView.backgroundColor;
        _carPriceFrontLabel.font = [UIFont systemFontOfSize:16];
        _carPriceFrontLabel.textColor = ORANGE_TEXT_COLOR;
        _carPriceFrontLabel.numberOfLines = 0;
        [_carPriceFrontLabel sizeToFit];
    }
    return _carPriceFrontLabel;
}

- (UILabel *)carPriceBehindLabel
{
    if (!_carPriceBehindLabel)
    {
        _carPriceBehindLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_carPriceBehindLabel];
        _carPriceBehindLabel.backgroundColor = self.contentView.backgroundColor;
        _carPriceBehindLabel.font = [UIFont systemFontOfSize:13];
        _carPriceBehindLabel.textColor = ORANGE_TEXT_COLOR;
        _carPriceBehindLabel.numberOfLines = 0;
        [_carPriceBehindLabel sizeToFit];
    }
    return _carPriceBehindLabel;
}

- (UIView *)separatorLine
{
    if (!_separatorLine)
    {
        _separatorLine = [[UIView alloc] init];
        [self.contentView addSubview:_separatorLine];
        _separatorLine.backgroundColor = UIColorFromRGB(0xEBEBEB);
    }
    return _separatorLine;
}

- (UILabel *)isEnddownLabel
{
    if (!_isEnddownLabel)
    {
        _isEnddownLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_isEnddownLabel];
        _isEnddownLabel.hidden = YES;
        _isEnddownLabel.backgroundColor = UIAlphaColorFromRGB(0x000000, 0.3);
        _isEnddownLabel.font = [UIFont systemFontOfSize:14.0];
        _isEnddownLabel.textColor = [UIColor whiteColor];
        _isEnddownLabel.text = @"已下架";
        [_isEnddownLabel sizeToFit];
    }
    return _isEnddownLabel;
}

@end
