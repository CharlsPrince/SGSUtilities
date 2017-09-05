/*!
 *  @file SGSToast.m
 *
 *  @author Created by Lee on 2017/2/8.
 *
 *  @copyright 2017年 SouthGIS. All rights reserved.
 */

#import "SGSToast.h"

static const NSTimeInterval kDefaultToastDismissDuration = 2;

@implementation SGSToast {
    BOOL _willHide;
}

- (instancetype)initWithMessage:(NSString *)message {
    if (message.length == 0) return nil;
    
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    NSDictionary *textAttribute = @{NSFontAttributeName: font};
    
    CGSize screenSize    = [UIScreen mainScreen].bounds.size;
    CGSize limitSize = CGSizeMake(screenSize.width * 0.85, screenSize.height * 0.85);
    
    CGSize messageSize = [message boundingRectWithSize:limitSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttribute context:NULL].size;
    
    CGRect frame = CGRectMake(0.0, 0.0, messageSize.width + 18.0, messageSize.height + 15.0);
    
    self = [super initWithFrame:frame];
    if (self) {
        _willHide = NO;
        
        self.font = font;
        self.text = message;
        self.textColor = [UIColor whiteColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.numberOfLines = 0;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 8.0;
        
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toastTapAction:)]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
}

// 点击 Toast
- (void)toastTapAction:(UITapGestureRecognizer *)sender {
    [self dismiss];
    _willHide = YES;
}

// 旋转屏幕
- (void)deviceOrientationDidChange:(NSNotification *)sender {
    [self dismiss];
    _willHide = YES;
}

- (void)showInView:(UIView *)view {
    if (view == nil) return;
    
    self.alpha = 0.0;
    [view addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
    }];
}

- (void)dismiss {
    if (_willHide) return;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showInView:(UIView *)view center:(CGPoint)center duration:(NSTimeInterval)duration {
    self.center = center;
    [self showInView:view];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:duration];
}

#pragma mark - Public

+ (void)showInView:(UIView *)view message:(NSString *)message {
    [self showInView:view message:message duration:kDefaultToastDismissDuration];
}

+ (void)showInView:(UIView *)view message:(NSString *)message topOffset:(CGFloat)topOffset {
    [self showInView:view message:message topOffset:topOffset duration:kDefaultToastDismissDuration];
}

+ (void)showInView:(UIView *)view message:(NSString *)message bottomOffset:(CGFloat)bottomOffset {
    [self showInView:view message:message bottomOffset:bottomOffset duration:kDefaultToastDismissDuration];
}

+ (void)showInView:(UIView *)view message:(NSString *)message duration:(NSTimeInterval)duration {
    if (view == nil) view = [[UIApplication sharedApplication] keyWindow];
    SGSToast *toast = [[SGSToast alloc] initWithMessage:message];
    
    if (toast != nil) {
        if (duration <= 0.0) duration = kDefaultToastDismissDuration;
        [toast showInView:view center:view.center duration:duration];
    }
}

+ (void)showInView:(UIView *)view message:(NSString *)message topOffset:(CGFloat)topOffset duration:(NSTimeInterval)duration {
    if (view == nil) view = [[UIApplication sharedApplication] keyWindow];
    SGSToast *toast = [[SGSToast alloc] initWithMessage:message];
    
    if (toast != nil) {
        if (duration <= 0.0) duration = kDefaultToastDismissDuration;
        CGPoint center = view.center;
        
        if (topOffset + toast.bounds.size.height < view.bounds.size.height) {
            center.y = topOffset + toast.bounds.size.height / 2;
        }
        
        [toast showInView:view center:center duration:duration];
    }
}

+ (void)showInView:(UIView *)view message:(NSString *)message bottomOffset:(CGFloat)bottomOffset duration:(NSTimeInterval)duration {
    if (view == nil) view = [[UIApplication sharedApplication] keyWindow];
    SGSToast *toast = [[SGSToast alloc] initWithMessage:message];
    
    if (toast != nil) {
        if (duration <= 0.0) duration = kDefaultToastDismissDuration;
        CGPoint center = view.center;
        
        if (bottomOffset + toast.bounds.size.height < view.bounds.size.height) {
            center.y = view.bounds.size.height - (bottomOffset + toast.bounds.size.height / 2);
        }
        
        [toast showInView:view center:center duration:duration];
    }
}

@end

@implementation SGSToast (ShowInWindowConvenience)

+ (void)showWithMessage:(NSString *)message {
    [self showInView:nil message:message duration:kDefaultToastDismissDuration];
}

+ (void)showWithMessage:(NSString *)message topOffset:(CGFloat)topOffset {
    [self showInView:nil message:message topOffset:topOffset duration:kDefaultToastDismissDuration];
}

+ (void)showWithMessage:(NSString *)message bottomOffset:(CGFloat)bottomOffset {
    [self showInView:nil message:message bottomOffset:bottomOffset duration:kDefaultToastDismissDuration];
}

+ (void)showWithMessage:(NSString *)message duration:(NSTimeInterval)duration {
    [self showInView:nil message:message duration:duration];
}

+ (void)showWithMessage:(NSString *)message topOffset:(CGFloat)topOffset duration:(NSTimeInterval)duration {
    [self showInView:nil message:message topOffset:topOffset duration:duration];
}

+ (void)showWithMessage:(NSString *)message bottomOffset:(CGFloat)bottomOffset duration:(NSTimeInterval)duration {
    [self showInView:nil message:message bottomOffset:bottomOffset duration:duration];
}

@end
