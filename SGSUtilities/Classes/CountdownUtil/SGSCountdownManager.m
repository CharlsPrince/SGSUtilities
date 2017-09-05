/*!
 *  @file SGSCountdownManager.m
 *
 *  @author Created by Lee on 16/5/13.
 *
 *  @copyright 2016年 SouthGIS. All rights reserved.
 */

#import "SGSCountdownManager.h"
#import "SGSCountdownTask.h"

@interface SGSCountdownManager () 
@property (nonatomic, strong) NSMutableDictionary *countdownTaskMutDict;
@property (nonatomic, strong) NSLock *lock;
@end

static SGSCountdownManager *sharedInstance;

@implementation SGSCountdownManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
        sharedInstance.countdownTaskMutDict = [NSMutableDictionary dictionary];
        sharedInstance.lock = [[NSLock alloc] init];
        sharedInstance.lock.name = @"SGSCountdownTaskLock";
        
    });
    return sharedInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
    });
    return sharedInstance;
}


// 进行倒计时
- (BOOL)scheduledCountdownWithIdentifier:(NSString *)identifier
                            timeInterval:(NSTimeInterval)timeInterval
                         runInBackground:(BOOL)runInBackground
        finishIdenticalTaskAndInvalidate:(BOOL)finishAndInvalidate
                         countingHandler:(void (^)(NSTimeInterval))countingHandler
                         finishedHandler:(void (^)(NSTimeInterval))finishedHandler
{
    if (identifier.length == 0) return NO;
    
    SGSCountdownTask *oldTask = [self countdownTaskWithIdentifier:identifier];
    if (oldTask != nil) {
        if (finishAndInvalidate) {
            [oldTask cancel];
            [self endBackgroundTask:oldTask];
        } else {
            return YES;
        }
    }
    
    __weak typeof(self) weakSelf = self;
    SGSCountdownTask *task = [[SGSCountdownTask alloc] initWithIdentifier:identifier countingHandler:countingHandler finishedHandler:^(NSTimeInterval timeInterval) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf addCountdownTask:nil withIdentifier:identifier];
        [strongSelf endBackgroundTask:oldTask];
        if (finishedHandler != nil) {
            finishedHandler(timeInterval);
        }
    }];
    
    if (runInBackground) {
        task.backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithName:identifier expirationHandler:nil];
    }
    
    [self addCountdownTask:task withIdentifier:identifier];
    [task scheduledWithTimeout:timeInterval];
    
    return YES;
}

// 添加倒计时任务
- (void)addCountdownTask:(SGSCountdownTask *)task withIdentifier:(NSString *)identifier {
    [self.lock lock];
    self.countdownTaskMutDict[identifier] = task;
    [self.lock unlock];
}

// 获取倒计时任务
- (SGSCountdownTask *)countdownTaskWithIdentifier:(NSString *)identifier {
    SGSCountdownTask *task = nil;
    [self.lock lock];
    task = self.countdownTaskMutDict[identifier];
    [self.lock unlock];
    
    return task;
}

// 强制结束倒计时
- (void)finishCountdownTaskAndInvalidateByIdentifier:(NSString *)identifier {
    SGSCountdownTask *task = [self countdownTaskWithIdentifier:identifier];
    if (task == nil) return;
    
    if (task.isCounting) {
        [task cancel];
    }
    
    [self endBackgroundTask:task];
    [self addCountdownTask:nil withIdentifier:identifier];
}

// 判断倒计时任务是否存在
- (BOOL)countdownTaskExistsByIdentifier:(NSString *)identifier {
    return ([self countdownTaskWithIdentifier:identifier] != nil);
}

// 判断倒计时任务是否正在进行
- (BOOL)taskIsCountingByIdentifier:(NSString *)identifier {
    SGSCountdownTask *task = [self countdownTaskWithIdentifier:identifier];
    return task.isCounting;
}

- (void)endBackgroundTask:(SGSCountdownTask *)task {
    if (task.backgroundTaskIdentifier > 0) {
        [[UIApplication sharedApplication] endBackgroundTask:task.backgroundTaskIdentifier];
        task.backgroundTaskIdentifier = 0;
    }
}

@end
