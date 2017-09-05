/*!
 *  @file SGSCityTableViewCell.h
 *
 *  @abstract 城市cell
 *
 *  @author Created by Lee on 16/10/21.
 *
 *  @copyright 2016年 SouthGIS. All rights reserved.
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 *  城市cell
 */
@interface SGSCityTableViewCell : UITableViewCell

/*! 顶部边距 */
+ (CGFloat)topPadding;

/*! 底部边距 */
+ (CGFloat)bottomPadding;

/*! 城市选项宽度 */
+ (CGFloat)cityItemWidth;

@end


NS_ASSUME_NONNULL_END
