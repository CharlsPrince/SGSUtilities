/*!
 *  @file SGSCountdownableButton.h
 *
 *  @abstract 倒计时功能的按钮
 *
 *  @author Created by Lee on 16/5/13.
 *
 *  @copyright 2016年 SouthGIS. All rights reserved.
 */

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@protocol SGSCountdownableButtonDelegate;

/*!
 *  拥有倒计时功能的按钮
 */
@interface SGSCountdownableButton : UIButton

/*! 倒计时标识符 */
@property (nonatomic, copy, readonly) NSString *identifier;

/*! 倒计时代理 */
@property (nonatomic, weak) id<SGSCountdownableButtonDelegate> countdownDelegate;

/*! 是否要在后台运行 */
@property (nonatomic, assign, getter=isRunInBackground) BOOL runInBackground;

/*! 是否处于倒计时状态 */
@property (nonatomic, assign, readonly, getter=isCounting) BOOL counting;


/*!
 *  根据类型和倒计时标识符实例化按钮
 *
 *  @param buttonType 按钮类型
 *  @param identifier 倒计时标识符
 *  @param delegate   代理
 *
 *  @return SGSCountdownableButton
 */
+ (instancetype)buttonWithType:(UIButtonType)buttonType
                    identifier:(NSString *)identifier
             countdownDelegate:(id<SGSCountdownableButtonDelegate>)delegate;

/*!
 *  指定初始化方法
 *
 *  @param frame      位置
 *  @param identifier 倒计时标识符
 *  @param delegate   代理
 *
 *  @return SGSCountdownableButton
 */
- (instancetype)initWithFrame:(CGRect)frame
                   identifier:(NSString *)identifier
            countdownDelegate:(id<SGSCountdownableButtonDelegate>)delegate;

/*!
 *  根据标识符设置倒计时任务和代理
 *
 *  @param identifier 倒计时标识符
 *  @param delegate   代理
 */
- (void)configureWithIdentifier:(NSString *)identifier
              countdownDelegate:(id<SGSCountdownableButtonDelegate>)delegate;

/*!
 *  开启倒计时，如果之前有相同的identifier倒计时任务，那么将会继续沿用
 *
 *  @param timeoutSecond 倒计时间
 */
- (void)countdownWithTimeout:(NSInteger)timeoutSecond finishIdenticalTaskAndInvalidate:(BOOL)finishAndInvalidate;

/*!
 *  停止倒计时
 */
- (void)stopCounting;

@end



#pragma mark - CountdownableButtonDelegate

/*!
 *  倒计时代理协议
 */
@protocol SGSCountdownableButtonDelegate <NSObject>

@optional

/*!
 *  按钮处于倒计时中
 *
 *  @param button    按钮
 *  @param restTimer 剩余时间
 */
- (void)button:(SGSCountdownableButton *)button countingWithRestTimer:(NSInteger)restTimer;

/*!
 *  按钮倒计时完毕
 *
 *  @param button 按钮
 */
- (void)buttonCountdownOver:(SGSCountdownableButton *)button;

@end

NS_ASSUME_NONNULL_END
