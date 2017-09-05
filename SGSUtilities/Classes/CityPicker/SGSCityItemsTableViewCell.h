/*!
 *  @file SGSCityItemsTableViewCell.h
 *
 *  @abstract 城市选项cell
 *
 *  @author Created by Lee on 16/10/21.
 *
 *  @copyright 2016年 SouthGIS. All rights reserved.
 */

#import "SGSCityTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 *  城市选项cell
 */
@interface SGSCityItemsTableViewCell : SGSCityTableViewCell

@property (nonatomic, assign) CGFloat suggestedCellHeight;

/*! 城市集合 */
@property (nullable, nonatomic, strong) NSArray<NSString *> *cities;

/*! 选择回调 */
@property (nullable, nonatomic, copy) void (^selectCityAction)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
