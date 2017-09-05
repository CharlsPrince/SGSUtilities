/*!
 *  @file UIViewController-SGSToast.h
 *
 *  @abstract 仿安卓Toast
 *
 *  @author Created by Lee on 2017/2/8.
 *
 *  @copyright 2017年 SouthGIS. All rights reserved.
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (SGSToast)

/*!
 *  在屏幕中间显示 Toast，默认消失时间为2秒
 *
 *  @param message 提示消息
 */
- (void)showToastWithMessage:(NSString *)message;


/*!
 *  根据屏幕顶部偏移量显示 Toast，默认消失时间为2秒
 *
 *  @param message   提示消息
 *  @param topOffset 距离屏幕顶部的偏移量
 */
- (void)showToastWithMessage:(NSString *)message topOffset:(CGFloat)topOffset;


/*!
 *  根据屏幕底部偏移量显示 Toast，默认消失时间为2秒
 *
 *  @param message      提示消息
 *  @param bottomOffset 距离屏幕底部的偏移量
 */
- (void)showToastWithMessage:(NSString *)message bottomOffset:(CGFloat)bottomOffset;


/*!
 *  在屏幕中间显示 Toast
 *
 *  @param message  提示消息
 *  @param duration Toast 消失时间间隔，小于等于0则默认为2秒
 */
- (void)showToastWithMessage:(NSString *)message duration:(NSTimeInterval)duration;


/*!
 *  根据屏幕顶部偏移量显示 Toast
 *
 *  @param message   提示消息
 *  @param topOffset 距离屏幕顶部的偏移量
 *  @param duration  消失时间间隔，小于等于0则默认为2秒
 */
- (void)showToastWithMessage:(NSString *)message topOffset:(CGFloat)topOffset duration:(NSTimeInterval)duration;


/*!
 *  根据屏幕底部偏移量显示 Toast
 *
 *  @param message      提示信息
 *  @param bottomOffset 距离屏幕底部的偏移量
 *  @param duration     消失时间间隔，小于等于0则默认为2秒
 */
- (void)showToastWithMessage:(NSString *)message bottomOffset:(CGFloat)bottomOffset duration:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END
