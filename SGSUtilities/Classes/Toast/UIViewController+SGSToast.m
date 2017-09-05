/*!
 *  @file UIViewController+SGSToast.m
 *
 *  @author Created by Lee on 2017/2/8.
 *
 *  @copyright 2017年 SouthGIS. All rights reserved.
 */

#import "UIViewController+SGSToast.h"
#import "SGSToast.h"

@implementation UIViewController (SGSToast)

- (UIView *)rootView {
    if ([self.view isKindOfClass:[UIScrollView class]] && (self.navigationController.view != nil)) {
        return self.navigationController.view;
    } else {
        return self.view;
    }
}

- (void)showToastWithMessage:(NSString *)message {
    [SGSToast showInView:[self rootView] message:message];
}

- (void)showToastWithMessage:(NSString *)message topOffset:(CGFloat)topOffset {
    [SGSToast showInView:[self rootView] message:message topOffset:topOffset];
}

- (void)showToastWithMessage:(NSString *)message bottomOffset:(CGFloat)bottomOffset {
    [SGSToast showInView:[self rootView] message:message bottomOffset:bottomOffset];
}

- (void)showToastWithMessage:(NSString *)message duration:(NSTimeInterval)duration {
    [SGSToast showInView:[self rootView] message:message duration:duration];
}

- (void)showToastWithMessage:(NSString *)message topOffset:(CGFloat)topOffset duration:(NSTimeInterval)duration {
    [SGSToast showInView:[self rootView] message:message topOffset:topOffset duration:duration];
}

- (void)showToastWithMessage:(NSString *)message bottomOffset:(CGFloat)bottomOffset duration:(NSTimeInterval)duration {
    [SGSToast showInView:[self rootView] message:message bottomOffset:bottomOffset duration:duration];
}

@end
