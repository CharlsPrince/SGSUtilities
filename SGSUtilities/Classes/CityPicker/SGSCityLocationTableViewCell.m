/*!
 *  @file SGSCityLocationTableViewCell.m
 *
 *  @author Created by Lee on 16/10/21.
 *
 *  @copyright 2016年 SouthGIS. All rights reserved.
 */

#import "SGSCityLocationTableViewCell.h"
#import "SGSCityPickerDefine.h"

static NSString * const kLocationButtonDefaultTitle = @"获取定位";

@interface UIImage (SGSCityPicker)
+ (UIImage *)imageWithColor:(UIColor *)color;
@end

@implementation UIImage (SGSCityPicker)
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = {0, 0, 1, 1};
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end

@interface SGSCityLocationTableViewCell ()
@property (nonatomic, strong, readwrite) UIButton *locationButton;
@end

@implementation SGSCityLocationTableViewCell

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self setupSubviews];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)setupSubviews {
    _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _locationButton.layer.cornerRadius = 3.0;
    _locationButton.layer.masksToBounds = YES;
    _locationButton.layer.borderWidth = 0.5;
    _locationButton.layer.borderColor = SGSCityPickerItemCellBackgroupdColor().CGColor;
    _locationButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    _locationButton.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
    
    [_locationButton setTitle:kLocationButtonDefaultTitle forState:UIControlStateNormal];
    [_locationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_locationButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_locationButton setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
    
    [self.contentView addSubview:_locationButton];
    
    CGFloat topPadding = [SGSCityLocationTableViewCell topPadding];
    CGFloat leftPadding = self.separatorInset.left;
    CGFloat buttonHeight = [SGSCityLocationTableViewCell suggestedCellHeight] - [SGSCityLocationTableViewCell topPadding] - [SGSCityLocationTableViewCell bottomPadding];
    CGFloat buttonWidth = [SGSCityLocationTableViewCell cityItemWidth];
    
    _locationButton.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *bindingViews = @{@"locationButton": _locationButton};
    NSDictionary *metrics = @{@"top": @(topPadding), @"left": @(leftPadding), @"height": @(buttonHeight), @"width": @(buttonWidth)};
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-left-[locationButton(>=width)]" options:kNilOptions metrics:metrics views:bindingViews]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[locationButton(height)]" options:kNilOptions metrics:metrics views:bindingViews]];
}

+ (CGFloat)suggestedCellHeight {
    return 51;
}

- (void)setLocationButtonTitle:(NSString *)title {
    if (title.length == 0) {
        title = kLocationButtonDefaultTitle;
    }
    [_locationButton setTitle:title forState:UIControlStateNormal];
}

@end
