/*!
 *  @file SGSCountdownableButton.m
 *
 *  @author Created by Lee on 16/5/13.
 *
 *  @copyright 2016年 SouthGIS. All rights reserved.
 */

#import "SGSCountdownableButton.h"
#import "SGSCountdownManager.h"

@interface SGSCountdownableButton ()
@property (nonatomic, copy, readwrite) NSString *identifier;
@end

@implementation SGSCountdownableButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType identifier:(NSString *)identifier countdownDelegate:(id<SGSCountdownableButtonDelegate>)delegate {
    SGSCountdownableButton *button = [SGSCountdownableButton buttonWithType:buttonType];
    [button configureWithIdentifier:identifier countdownDelegate:delegate];
    return button;
}

- (instancetype)initWithFrame:(CGRect)frame identifier:(NSString *)identifier countdownDelegate:(id<SGSCountdownableButtonDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureWithIdentifier:identifier countdownDelegate:delegate];
    }
    return self;
}

- (void)configureWithIdentifier:(NSString *)identifier countdownDelegate:(nonnull id<SGSCountdownableButtonDelegate>)delegate {
    self.identifier = identifier;
    self.countdownDelegate = delegate;
    SGSCountdownTask *task = [[SGSCountdownManager sharedManager] countdownTaskWithIdentifier:identifier];
    
    if (task != nil) {
        __weak typeof(&*self) weakSelf = self;
        
        [task setCountingHandler:^(NSTimeInterval leftTimeInterval) {
            NSInteger seconds = (NSInteger)leftTimeInterval % 60;
            if ([weakSelf.countdownDelegate respondsToSelector:@selector(button:countingWithRestTimer:)]) {
                [weakSelf.countdownDelegate button:weakSelf countingWithRestTimer:seconds];
            }
        }];
        
        [task setFinishedHandler:^(NSTimeInterval finalTimeInterval) {
            [[SGSCountdownManager sharedManager] finishCountdownTaskAndInvalidateByIdentifier:weakSelf.identifier];
            if ([weakSelf.countdownDelegate respondsToSelector:@selector(buttonCountdownOver:)]) {
                [weakSelf.countdownDelegate buttonCountdownOver:weakSelf];
            }
        }];
    }
}

- (void)countdownWithTimeout:(NSInteger)timeoutSecond finishIdenticalTaskAndInvalidate:(BOOL)finishAndInvalidate {
    __weak typeof(self) weakSelf = self;
    
    [[SGSCountdownManager sharedManager] scheduledCountdownWithIdentifier:self.identifier timeInterval:timeoutSecond runInBackground:self.runInBackground finishIdenticalTaskAndInvalidate:finishAndInvalidate countingHandler:^(NSTimeInterval timeInterval) {
        NSInteger seconds = (NSInteger)timeInterval % 60;
        if ([weakSelf.countdownDelegate respondsToSelector:@selector(button:countingWithRestTimer:)]) {
            [weakSelf.countdownDelegate button:weakSelf countingWithRestTimer:seconds];
        }
        
    } finishedHandler:^(NSTimeInterval finalTimeInterval) {
        if ([weakSelf.countdownDelegate respondsToSelector:@selector(buttonCountdownOver:)]) {
            [weakSelf.countdownDelegate buttonCountdownOver:weakSelf];
        }
    }];
}


- (void)stopCounting {
    [[SGSCountdownManager sharedManager] finishCountdownTaskAndInvalidateByIdentifier:self.identifier];
}

- (BOOL)isCounting {
    return [[SGSCountdownManager sharedManager] taskIsCountingByIdentifier:self.identifier];
}

@end
