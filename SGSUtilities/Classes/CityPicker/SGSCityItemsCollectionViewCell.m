/*!
 *  @file SGSCityItemsCollectionViewCell.m
 *
 *  @author Created by Lee on 16/10/21.
 *
 *  @copyright 2016年 SouthGIS. All rights reserved.
 */

#import "SGSCityItemsCollectionViewCell.h"
#import "SGSCityPickerDefine.h"

@interface SGSCityItemsCollectionViewCell ()
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@end

@implementation SGSCityItemsCollectionViewCell

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    _titleLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
    _titleLabel.layer.cornerRadius = 3.0;
    _titleLabel.layer.masksToBounds = YES;
    _titleLabel.layer.borderWidth = 0.5;
    _titleLabel.layer.borderColor = SGSCityPickerItemCellBackgroupdColor().CGColor;
    _titleLabel.backgroundColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:15.0];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_titleLabel];
    
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *bindingViews = @{@"title": _titleLabel};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[title]-0-|" options:kNilOptions metrics:nil views:bindingViews]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[title]-0.5-|" options:kNilOptions metrics:nil views:bindingViews]];
}

@end
