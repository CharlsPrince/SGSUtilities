/*!
 *  @file SGSCityLocationTableViewCell.h
 *
 *  @abstract 城市定位cell
 *
 *  @author Created by Lee on 16/10/21.
 *
 *  @copyright 2016年 SouthGIS. All rights reserved.
 */

#import "SGSCityTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 *  城市定位cell
 */
@interface SGSCityLocationTableViewCell : SGSCityTableViewCell

@property (nonatomic, strong, readonly) UIButton *locationButton;

+ (CGFloat)suggestedCellHeight;

- (void)setLocationButtonTitle:(nullable NSString *)title;

@end

NS_ASSUME_NONNULL_END
