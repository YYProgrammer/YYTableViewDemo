//
//  YYHighPerTableViewCell.m
//  bjesc
//
//  Created by yuyou on 2017/9/5.
//  Copyright © 2017年 bjjd. All rights reserved.
//

#import "YYHighPerTableViewCell.h"
#import "YYHighPerCarModel.h"
#import "UIImageView+WebCache.h"
#import "YYKit.h"
#import "Masonry.h"


#define TIP_IMAGE_WIDTH_IN_SMALL_CELL 40.0
#define TIP_IMAGE_WIDTH_IN_BIG_CELL 44.0
#define NEW_CAR_IMAGE_WIDTH_IN_SMALL_CELL 38
#define NEW_CAR_IMAGE_WIDTH_IN_BIG_CELL 50
#define TIP_IMAGE_TOP_OFFSET_PROPORTION (5.0 / 62.0)

static float CELL_HEIGHT = 15.0 + 80 + 15 + 1;

@interface YYHighPerTableViewCell ()

@property (nonatomic,strong) UIImageView *carImageView;//展示图
@property (nonatomic,strong) UIImageView *carDepreciateTip;//降价标签
@property (nonatomic,strong) UILabel *carDepreciateLabel;//降价金额
@property (nonatomic,strong) UIImageView *carNewTip;//新上标签
@property (nonatomic,strong) YYLabel *carVersionLabel;//车型
@property (nonatomic,strong) YYLabel *carDescribeLabel;//描述
@property (nonatomic,strong) YYLabel *carPriceLabel;//价格(大字加小字)
@property (nonatomic,strong) UIView *separatorLine;//分割线
@property (nonatomic,strong) UILabel *fixedLabel;//已将文字label
@property (nonatomic,strong) UILabel *isEnddownLabel;//下架文字标签

@end

@implementation YYHighPerTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"YYHighPerTableViewCell";
    
    YYHighPerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[YYHighPerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
        //把一些固定的view在这里设置frame，少在layout中做点事，可以解决卡顿问题
        cell.carImageView.frame = CGRectMake(15, 10, 120, 90);
        cell.carDepreciateTip.frame = CGRectMake(15, (15 - (TIP_IMAGE_TOP_OFFSET_PROPORTION * (TIP_IMAGE_WIDTH_IN_SMALL_CELL * 62 / 68))), TIP_IMAGE_WIDTH_IN_SMALL_CELL, TIP_IMAGE_WIDTH_IN_SMALL_CELL * 62 / 68);
        cell.carNewTip.frame = CGRectMake(15, 15, NEW_CAR_IMAGE_WIDTH_IN_SMALL_CELL, NEW_CAR_IMAGE_WIDTH_IN_SMALL_CELL * 26 / 78);
        cell.isEnddownLabel.yy_x = cell.carImageView.yy_x;
        cell.isEnddownLabel.yy_y = CGRectGetMaxY(cell.carImageView.frame) - cell.isEnddownLabel.yy_height;
        cell.separatorLine.frame = CGRectMake(15, [YYHighPerTableViewCell getCellHeight] - 1, kMainScreenWidth - 15, 1);
        cell.carVersionLabel.frame = CGRectMake(CGRectGetMaxX(cell.carImageView.frame) + 10, cell.carImageView.yy_y + 3, CAR_VERSION_LABEL_WIDTH, 100);
        cell.carDescribeLabel.frame = CGRectMake(cell.carVersionLabel.yy_x, 0, cell.carVersionLabel.yy_width, CAR_DESCRIBE_LABEL_HEIGHT);
        cell.carPriceLabel.frame = CGRectMake(cell.carVersionLabel.yy_x, CGRectGetMaxY(cell.carImageView.frame) - CAR_PRICE_LABEL_HEIGHT - 1, cell.carVersionLabel.yy_width, CAR_PRICE_LABEL_HEIGHT);
    }
    return cell;
}

+ (CGFloat)getCellHeight
{
    return CELL_HEIGHT;
}

- (void)setModel:(YYHighPerCarModel *)model
{
    _model = model;
    
    //赋值
    if (model.imgUrl != nil && ![model.imgUrl isEqualToString:@""])
    {
        [self.carImageView setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholder:[YYHighPerCarModel sharedPlaceHolderImage] options:kNilOptions manager:[YYHighPerCarModel avatarImageManager] progress:nil transform:nil completion:nil];
    }
    else
    {
        self.carImageView.image = [YYHighPerCarModel sharedPlaceHolderImage];
    }
    
    
    if ([model.publishNew isEqualToString:@"1"])//新上
    {
        self.carDepreciateTip.hidden = YES;
        self.carNewTip.hidden = NO;
    }
    else if ((model.poor != nil) && (![model.poor isEqualToString:@""]))
    {
        self.carDepreciateLabel.text = [NSString stringWithFormat:@"%@",model.poor];
        self.carDepreciateTip.hidden = NO;
        self.carNewTip.hidden = YES;
    }
    else
    {
        self.carDepreciateTip.hidden = YES;
        self.carNewTip.hidden = YES;
    }
    
    //车型label
    self.carVersionLabel.yy_height = model.carVersionLabelHeight;//修改高度
    self.carVersionLabel.textLayout = model.carVersionLabelLayout;//设置layout，异步绘制
    
    //上牌时间
    if (self.model.carVersionLabelLayout.rowCount > 1)//15号字体下，大于30的高必定是2行
    {
        self.carDescribeLabel.yy_y = self.carImageView.yy_centerY - self.carDescribeLabel.yy_height * 0.5 + 9.5;//调整位置
    }
    else
    {
        self.carDescribeLabel.yy_y = self.carImageView.yy_centerY - self.carDescribeLabel.yy_height * 0.5;//调整位置
    }
    self.carDescribeLabel.textLayout = model.carDescribeLabelLayout;//设置layout，异步绘制
    
    //车价
    self.carPriceLabel.textLayout = model.carPriceLabelLayout;//设置layout，异步绘制
    
    //下架标签
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
//        _carImageView.layer.cornerRadius = 5.0;
//        _carImageView.layer.masksToBounds = YES;
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

- (YYLabel *)carVersionLabel
{
    if (!_carVersionLabel)
    {
        _carVersionLabel = [[YYLabel alloc] init];
        [self.contentView addSubview:_carVersionLabel];
        _carVersionLabel.displaysAsynchronously = YES;
        _carVersionLabel.ignoreCommonProperties = YES;
        _carVersionLabel.fadeOnHighlight = NO;
        _carVersionLabel.fadeOnAsynchronouslyDisplay = NO;
    }
    return _carVersionLabel;
}

- (YYLabel *)carDescribeLabel
{
    if (!_carDescribeLabel)
    {
        _carDescribeLabel = [[YYLabel alloc] init];
        [self.contentView addSubview:_carDescribeLabel];
        _carDescribeLabel.displaysAsynchronously = YES;
        _carDescribeLabel.ignoreCommonProperties = YES;
        _carDescribeLabel.fadeOnHighlight = NO;
        _carDescribeLabel.fadeOnAsynchronouslyDisplay = NO;
    }
    return _carDescribeLabel;
}

- (YYLabel *)carPriceLabel
{
    if (!_carPriceLabel)
    {
        _carPriceLabel = [[YYLabel alloc] init];
        [self.contentView addSubview:_carPriceLabel];
        _carPriceLabel.displaysAsynchronously = YES;
        _carPriceLabel.ignoreCommonProperties = YES;
        _carPriceLabel.fadeOnHighlight = NO;
        _carPriceLabel.fadeOnAsynchronouslyDisplay = NO;
    }
    return _carPriceLabel;
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
        _isEnddownLabel.font = [UIFont systemFontOfSize:11.0];
        _isEnddownLabel.textColor = [UIColor whiteColor];
        _isEnddownLabel.text = @"已下架";
        [_isEnddownLabel sizeToFit];
    }
    return _isEnddownLabel;
}

@end

