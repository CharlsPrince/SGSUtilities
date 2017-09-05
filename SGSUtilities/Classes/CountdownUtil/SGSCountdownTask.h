/*!
 *  @file SGSCountdownTask.h
 *
 *  @abstract 倒计时任务类
 *
 *  @author Created by Lee on 16/5/13.
 *
 *  @copyright 2016年 SouthGIS. All rights reserved.
 */

@import Foundation;
@import UIKit.UIApplication;

NS_ASSUME_NONNULL_BEGIN

/*!
 *  倒计时任务类，只有一个倒计时任务时，推荐使用该类
 */
@interface SGSCountdownTask : NSObject

/*! 是否处于倒计时状态 */
@property (nonatomic, assign, readonly, getter=isCounting) BOOL counting;

/*! 倒计时任务标识符 */
@property (nonnull, nonatomic, copy) NSString *identifier;

/*! 计时进行中的回调Block */
@property (nullable, nonatomic, copy) void (^countingHandler)(NSTimeInterval leftTimeInterval);

/*! 计时结束后的回调Block */
@property (nullable, nonatomic, copy) void (^finishedHandler)(NSTimeInterval finalTimeInterval);

/*! 后台任务标识，确保App进入后台后依然能够进行计时 */
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

/*!
 *  @abstract 指定初始化方法
 *
 *  @param identifier      倒计时任务唯一标识符
 *  @param countingHandler 倒计时进行中的Block
 *  @param finishedHandler 倒计时完毕的Block
 *
 *  @return SGSCountdownTask or nil
 */
- (nullable instancetype)initWithIdentifier:(nullable NSString *)identifier
                            countingHandler:(nullable void (^)(NSTimeInterval leftTimeInterval))countingHandler
                            finishedHandler:(nullable void (^)(NSTimeInterval finalTimeInterval))finishedHandler NS_DESIGNATED_INITIALIZER;

/*!
 *  @abstract 开启倒计时
 *
 *  @discussion 由于操作系统后台限制，如果设置了backgroundTaskIdentifier，
 *              倒计时时间规定不得大于120秒，除非是音乐播放器或运动类APP
 *
 *  @param timeInterval 倒计时时间
 */
- (void)scheduledWithTimeout:(NSTimeInterval)timeout;


/*!
 *  @abstract 停止倒计时
 */
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
