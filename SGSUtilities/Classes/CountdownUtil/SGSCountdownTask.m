/*!
 *  @file SGSCountdownTask.m
 *
 *  @author Created by Lee on 16/5/13.
 *
 *  @copyright 2016年 SouthGIS. All rights reserved.
 */

#import "SGSCountdownTask.h"

@interface SGSCountdownTask ()

/** 是否处于倒计时状态 */
@property (nonatomic, assign, readwrite, getter=isCounting) BOOL counting;

/** 倒计时定时器 */
@property (nonatomic, unsafe_unretained) dispatch_source_t countdownTimer;

@end


@implementation SGSCountdownTask

- (instancetype)init {
    return [self initWithIdentifier:nil countingHandler:nil finishedHandler:nil];
}

- (instancetype)initWithIdentifier:(NSString *)identifier
                   countingHandler:(void (^)(NSTimeInterval))countingHandler
                   finishedHandler:(void (^)(NSTimeInterval))finishedHandler
{
    self = [super init];
    if (self) {
        _backgroundTaskIdentifier = 0;
        _identifier = identifier.copy;
        _countingHandler = [countingHandler copy];
        _finishedHandler = [finishedHandler copy];
    }
    return self;
}

- (void)dealloc {
    if (self.countdownTimer != NULL) {
        dispatch_source_cancel(self.countdownTimer);
        self.countdownTimer = NULL;
    }
    _countingHandler = nil;
    _finishedHandler = nil;
}

- (void)scheduledWithTimeout:(NSTimeInterval)timeout {
    __weak typeof(self) weakSelf = self;
    
    // 输入0或负数表示取消倒计时
    if (timeout <= 0) {
        if (weakSelf.countdownTimer != NULL) {
            dispatch_source_cancel(self.countdownTimer);
            weakSelf.countdownTimer = NULL;
            if (weakSelf.finishedHandler != nil) {
                weakSelf.finishedHandler(0);
            }
        }
        weakSelf.counting = NO;
        return ;
    }
    
    // 设置
    __block NSTimeInterval time = timeout;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    self.countdownTimer = timer;
    self.counting = YES;
    
    // 每秒执行
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    
    
    dispatch_source_set_event_handler(timer, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if(time <= 0){
            // 倒计时结束，关闭
            dispatch_source_cancel(timer);
            strongSelf.countdownTimer = NULL;
            strongSelf.counting = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (strongSelf.finishedHandler != nil) {
                    strongSelf.finishedHandler(0);
                }
            });
        }else{
            // 倒计时中
            dispatch_async(dispatch_get_main_queue(), ^{
                if (strongSelf.countingHandler != nil) {
                    strongSelf.countingHandler(time);
                }
            });
            time -= 1;
        }
    });
    // 执行
    dispatch_resume(timer);
    
}

- (void)cancel {
    [self scheduledWithTimeout:-1];
}

@end
