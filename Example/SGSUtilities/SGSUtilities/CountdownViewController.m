//
//  CountdownViewController.m
//  SGSUtilities
//
//  Created by Lee on 16/10/26.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "CountdownViewController.h"
#import <SGSUtilities/SGSCountdownableButton.h>

static NSString * const kCountdownIdentifier = @"CountdownButton";

@interface CountdownViewController () <SGSCountdownableButtonDelegate>
@property (nonatomic, strong) SGSCountdownableButton *countdownButton;

@end

@implementation CountdownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    _countdownButton = [[SGSCountdownableButton alloc] initWithFrame:CGRectMake(0, 100, screenWidth, 30) identifier:kCountdownIdentifier countdownDelegate:self];
    _countdownButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_countdownButton setTitle:@"倒计时按钮" forState:UIControlStateNormal];
    [_countdownButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_countdownButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_countdownButton addTarget:self action:@selector(countdownButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _countdownButton.runInBackground = YES;
    [self.view addSubview:_countdownButton];
    
    if (_countdownButton.isCounting) {
        _countdownButton.enabled = NO;
    }
}

- (void)countdownButtonClicked:(SGSCountdownableButton *)sender {
    NSLog(@"开始倒计时");
    if (!sender.isCounting) {
        sender.enabled = NO;
        [sender countdownWithTimeout:20 finishIdenticalTaskAndInvalidate:NO];
    }
}


#pragma mark - SGSCountdownableButtonDelegate

- (void)button:(SGSCountdownableButton *)button countingWithRestTimer:(NSInteger)restTimer {
    if ([button.identifier isEqualToString:kCountdownIdentifier]) {
        [button setTitle:[NSString stringWithFormat:@"倒计时按钮 (%ld s)", restTimer] forState:UIControlStateDisabled];
        button.enabled = NO;
    }
}

- (void)buttonCountdownOver:(SGSCountdownableButton *)button {
    if ([button.identifier isEqualToString:kCountdownIdentifier]) {
        [button setTitle:@"倒计时按钮" forState:UIControlStateNormal];
        [button setTitle:@"倒计时按钮" forState:UIControlStateDisabled];
        button.enabled = YES;
    }
}

@end
