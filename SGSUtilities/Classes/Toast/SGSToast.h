/*!
 *  @file SGSToast.h
 *
 *  @abstract 仿安卓Toast
 *
 *  @author Created by Lee on 2017/2/8.
 *
 *  @copyright 2017年 SouthGIS. All rights reserved.
 */

NS_ASSUME_NONNULL_BEGIN

/*!
 *  仿安卓的 Toast 控件
 */
@interface SGSToast : UILabel

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

/*!
 *  在视图中间显示 Toast，默认消失时间为2秒
 *
 *  @param view    待展示 Toast 的父视图，如果为 nil，那么将使用 [[UIApplication sharedApplication] keyWindow]
 *  @param message 提示消息
 */
+ (void)showInView:(nullable UIView *)view message:(NSString *)message;


/*!
 *  根据视图顶部偏移量显示 Toast，默认消失时间为2秒
 *
 *  @param view      待展示 Toast 的父视图，如果为 nil，那么将使用 [[UIApplication sharedApplication] keyWindow]
 *  @param message   提示消息
 *  @param topOffset 距离视图顶部的偏移量
 */
+ (void)showInView:(nullable UIView *)view message:(NSString *)message topOffset:(CGFloat)topOffset;


/*!
 *  根据视图底部偏移量显示 Toast，默认消失时间为2秒
 *
 *  @param view         待展示 Toast 的父视图，如果为 nil，那么将使用 [[UIApplication sharedApplication] keyWindow]
 *  @param message      提示消息
 *  @param bottomOffset 距离视图底部的偏移量
 */
+ (void)showInView:(nullable UIView *)view message:(NSString *)message bottomOffset:(CGFloat)bottomOffset;


/*!
 *  在视图中间显示 Toast
 *
 *  @param view     待展示 Toast 的父视图，如果为 nil，那么将使用 [[UIApplication sharedApplication] keyWindow]
 *  @param message  提示消息
 *  @param duration Toast 消失时间间隔，小于等于0则默认为2秒
 */
+ (void)showInView:(nullable UIView *)view message:(NSString *)message duration:(NSTimeInterval)duration;


/*!
 *  根据视图顶部偏移量显示 Toast
 *
 *  @param view      待展示 Toast 的父视图，如果为 nil，那么将使用 [[UIApplication sharedApplication] keyWindow]
 *  @param message   提示消息
 *  @param topOffset 距离视图顶部的偏移量
 *  @param duration  消失时间间隔，小于等于0则默认为2秒
 */
+ (void)showInView:(nullable UIView *)view message:(NSString *)message topOffset:(CGFloat)topOffset duration:(NSTimeInterval)duration;


/*!
 *  根据视图底部偏移量显示 Toast
 *
 *  @param view         待展示 Toast 的父视图，如果为 nil，那么将使用 [[UIApplication sharedApplication] keyWindow]
 *  @param message      提示信息
 *  @param bottomOffset 距离视图底部的偏移量
 *  @param duration     消失时间间隔，小于等于0则默认为2秒
 */
+ (void)showInView:(nullable UIView *)view message:(NSString *)message bottomOffset:(CGFloat)bottomOffset duration:(NSTimeInterval)duration;

@end


/*!
 *  直接在 Window 显示的便捷方法
 */
@interface SGSToast (ShowInWindowConvenience)

/*!
 *  在屏幕中间显示 Toast，默认消失时间为2秒
 *
 *  @param message 提示消息
 */
+ (void)showWithMessage:(NSString *)message;


/*!
 *  根据屏幕顶部偏移量显示 Toast，默认消失时间为2秒
 *
 *  @param message   提示消息
 *  @param topOffset 距离屏幕顶部的偏移量
 */
+ (void)showWithMessage:(NSString *)message topOffset:(CGFloat)topOffset;


/*!
 *  根据屏幕底部偏移量显示 Toast，默认消失时间为2秒
 *
 *  @param message      提示消息
 *  @param bottomOffset 距离屏幕底部的偏移量
 */
+ (void)showWithMessage:(NSString *)message bottomOffset:(CGFloat)bottomOffset;


/*!
 *  在屏幕中间显示 Toast
 *
 *  @param message  提示消息
 *  @param duration Toast 消失时间间隔，小于等于0则默认为2秒
 */
+ (void)showWithMessage:(NSString *)message duration:(NSTimeInterval)duration;


/*!
 *  根据屏幕顶部偏移量显示 Toast
 *
 *  @param message   提示消息
 *  @param topOffset 距离屏幕顶部的偏移量
 *  @param duration  消失时间间隔，小于等于0则默认为2秒
 */
+ (void)showWithMessage:(NSString *)message topOffset:(CGFloat)topOffset duration:(NSTimeInterval)duration;


/*!
 *  根据屏幕底部偏移量显示 Toast
 *
 *  @param message      提示信息
 *  @param bottomOffset 距离屏幕底部的偏移量
 *  @param duration     消失时间间隔，小于等于0则默认为2秒
 */
+ (void)showWithMessage:(NSString *)message bottomOffset:(CGFloat)bottomOffset duration:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END
