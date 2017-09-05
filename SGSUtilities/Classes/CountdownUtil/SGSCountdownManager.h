/*!
 *  @file SGSCountdownManager.h
 *
 *  @abstract 倒计时管理类
 *
 *  @author Created by Lee on 16/5/13.
 *
 *  @copyright 2016年 SouthGIS. All rights reserved.
 */

@import Foundation;
#import "SGSCountdownTask.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 *  @class SGSCountdownManager
 *
 *  @abstract 倒计时管理类
 *
 *  @classdesign 使用单例设计模式，用于同时管理多个倒计时功能模块,如果只有一个倒计时定时器推荐使用SGSCountdownTask实现
 */
@interface SGSCountdownManager : NSObject

/*!
 *  @abstract 单例
 */
+ (instancetype)sharedManager;

/*!
 *  @abstract 进行倒计时
 *
 *  @discussion  如果需要在后台运行，由于操作系统后台限制，
 *               倒计时时间规定不得大于120秒，除非是音乐播放器或运动类APP
 *
 *  @param identifier          倒计时任务标识符
 *  @param timeInterval        倒计时总时间
 *  @param runInBackground     是否在后台运行
 *  @param finishAndInvalidate 当有相同 identifier 倒计时任务时，如果该参数为 `YES`，
 *          那么将停止之前的任务，重新进行倒计时；如果该参数为 `NO`，那么继续沿用之前的倒计时任务
 *  @param countingHandler     进行倒计时的Block
 *  @param finishedHandler     倒计时结束时的Block
 *
 *  @return YES（成功执行），NO（执行不成功）
 */
- (BOOL)scheduledCountdownWithIdentifier:(NSString *)identifier
                            timeInterval:(NSTimeInterval)timeInterval
                         runInBackground:(BOOL)runInBackground
        finishIdenticalTaskAndInvalidate:(BOOL)finishAndInvalidate
                         countingHandler:(nullable void (^)(NSTimeInterval leftTimeInterval))countingHandler
                         finishedHandler:(nullable void (^)(__unused NSTimeInterval finalTimeInterval))finishedHandler;

/*!
 *  @abstract 添加倒计时任务
 *
 *  @param task       倒计时任务，如果传入nil则移除对应的倒计时任务，但不会停止
 *  @param identifier 倒计时任务标识符
 */
- (void)addCountdownTask:(nullable SGSCountdownTask *)task withIdentifier:(NSString *)identifier;

/*!
 *  @abstract 获取倒计时任务
 *
 *  @param identifier 倒计时任务标识符
 */
- (nullable SGSCountdownTask *)countdownTaskWithIdentifier:(NSString *)identifier;

/*!
 *  @abstract 强制结束倒计时，并且移除倒计时任务
 *
 *  @param identifier 倒计时任务标识符
 */
- (void)finishCountdownTaskAndInvalidateByIdentifier:(NSString *)identifier;


/*!
 *  @abstract 判断倒计时任务是否存在
 *
 *  @param identifier 倒计时任务标识符
 *
 *  @return YES（存在），NO（不存在）
 */
- (BOOL)countdownTaskExistsByIdentifier:(NSString *)identifier;

/*!
 *  @abstract 判断倒计时任务是否正在进行
 *
 *  @param identifier 倒计时任务标识符
 *
 *  @return YES（正在进行），NO（没有进行或不存在该倒计时任务）
 */
- (BOOL)taskIsCountingByIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
