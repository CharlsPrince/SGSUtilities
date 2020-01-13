/*!
 *  @file SGSSystemUtil.m
 *
 *  @author Created by Lee on 16/9/2.
 *
 *  @copyright 2016年 SouthGIS. All rights reserved.
 */

#import "SGSSystemUtil.h"

@implementation SGSSystemUtil

+ (void)openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options completionHandler:(void (^)(BOOL))completion {
    UIApplication *app = [UIApplication sharedApplication];
    
    if ([app respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        NSDictionary *opt = (options == nil) ? @{} : options;
        if (@available(iOS 10.0, *)) {
            [app openURL:url options:opt completionHandler:completion];
        } else {
            // Fallback on earlier versions
        }
    } else {
        BOOL result = [app openURL:url];
        if (completion != nil) {
            completion(result);
        }
    }
}

+ (void)openSafariWithURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options completionHandler:(void (^)(BOOL))completion {
    [self openURL:url options:options completionHandler:completion];
}

+ (void)openQQWithOptions:(NSDictionary<NSString *,id> *)options completionHandler:(void (^)(BOOL))completion {
    NSURL *url = [NSURL URLWithString:@"mqq://"];
    [self openURL:url options:options completionHandler:completion];
}

+ (void)openWeChatWithOptions:(NSDictionary<NSString *,id> *)options completionHandler:(void (^)(BOOL))completion {
    NSURL *url = [NSURL URLWithString:@"weixin://"];
    [self openURL:url options:options completionHandler:completion];
}

+ (void)openSinaWeiboWithOptions:(NSDictionary<NSString *,id> *)options completionHandler:(void (^)(BOOL))completion {
    NSURL *url = [NSURL URLWithString:@"sinaweibo://"];
    [self openURL:url options:options completionHandler:completion];
}

+ (void)openTencentWeiboWithOptions:(NSDictionary<NSString *,id> *)options completionHandler:(void (^)(BOOL))completion {
    NSURL *url = [NSURL URLWithString:@"TencentWeibo://"];
    [self openURL:url options:options completionHandler:completion];
}

+ (void)openAlipayWithOptions:(NSDictionary<NSString *,id> *)options completionHandler:(void (^)(BOOL))completion {
    NSURL *url = [NSURL URLWithString:@"alipay://"];
    [self openURL:url options:options completionHandler:completion];
}

+ (void)openTaobaoWithOptions:(NSDictionary<NSString *,id> *)options completionHandler:(void (^)(BOOL))completion {
    NSURL *url = [NSURL URLWithString:@"taobao://"];
    [self openURL:url options:options completionHandler:completion];;
}

+ (void)openTmallWithOptions:(NSDictionary<NSString *,id> *)options completionHandler:(void (^)(BOOL))completion {
    NSURL *url = [NSURL URLWithString:@"tmall://"];
    [self openURL:url options:options completionHandler:completion];
}

+ (void)openJDWithOptions:(NSDictionary<NSString *,id> *)options completionHandler:(void (^)(BOOL))completion {
    NSURL *url = [NSURL URLWithString:@"openApp.jdMobile://"];
    [self openURL:url options:options completionHandler:completion];
}

+ (void)openJDHDWithOptions:(NSDictionary<NSString *,id> *)options completionHandler:(void (^)(BOOL))completion {
    NSURL *url = [NSURL URLWithString:@"openApp.jdiPad://"];
    [self openURL:url options:options completionHandler:completion];
}

+ (void)openMeiTuanWithOptions:(NSDictionary<NSString *,id> *)options completionHandler:(void (^)(BOOL))completion {
    NSURL *url = [NSURL URLWithString:@"imeituan://"];
    [self openURL:url options:options completionHandler:completion];
}

+ (void)openBaiduMapWithOptions:(NSDictionary<NSString *,id> *)options completionHandler:(void (^)(BOOL))completion {
    NSURL *url = [NSURL URLWithString:@"baidumap://map/"];
    [self openURL:url options:options completionHandler:completion];
}

+ (void)openAMapWithOptions:(NSDictionary<NSString *,id> *)options completionHandler:(void (^)(BOOL))completion {
    NSURL *url = [NSURL URLWithString:@"iosamap://"];
    [self openURL:url options:options completionHandler:completion];
}

+ (void)openSoSoMapWithOptions:(NSDictionary<NSString *,id> *)options completionHandler:(void (^)(BOOL))completion {
    NSURL *url = [NSURL URLWithString:@"sosomap://"];
    [self openURL:url options:options completionHandler:completion];
}

+ (void)callWithPhoneNumber:(NSString *)phone completionHandler:(void (^)(BOOL))completion {
    NSString *str = [NSString stringWithFormat:@"tel://%@", phone];
    NSURL *url = [NSURL URLWithString:str];
    [self openURL:url options:nil completionHandler:completion];
}

+ (void)sendSMSWithPhoneNumber:(NSString *)phone completionHandler:(void (^)(BOOL))completion {
    NSString *str = [NSString stringWithFormat:@"sms://%@", phone];
    NSURL *url = [NSURL URLWithString:str];
    [self openURL:url options:nil completionHandler:completion];
}

+ (void)sendEmailToAddress:(NSString *)address completionHandler:(void (^)(BOOL))completion {
    NSString *str = [NSString stringWithFormat:@"mailto://%@", address];
    NSURL *url = [NSURL URLWithString:str];
    [self openURL:url options:nil completionHandler:completion];
}

+ (void)gotoAppSettingWithCompletionHandler:(void (^)(BOOL))completion {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [self openURL:url options:nil completionHandler:completion];
}

+ (BOOL)gotoWiFiServices {
    return NO;
}

+ (BOOL)gotoCellularServices {
    return NO;
}

+ (BOOL)gotoBluetoothServices {
    return NO;
}

+ (BOOL)gotoNotificationsServices {
    return NO;
}

+ (BOOL)gotoGeneralServices {
    return NO;
}

+ (BOOL)gotoAboutServices {
    return NO;
}

+ (BOOL)gotoSoftwareUpdateServices {
    return NO;
}

+ (BOOL)gotoSiriServices {
    return NO;
}

+ (BOOL)gotoAccessibilityServices {
    return NO;
}

+ (BOOL)gotoAutoLockServices {
    return NO;
}

+ (BOOL)gotoDateAndTimeServices {
    return NO;
}

+ (BOOL)gotoKeyboardServices {
    return NO;
}

+ (BOOL)gotoInternationalServices {
    return NO;
}

+ (BOOL)gotoManagedConfigurationServices {
    return NO;
}

+ (BOOL)gotoResetServices {
    return NO;
}

+ (BOOL)gotoWallpaperServices {
    return NO;
}

+ (BOOL)gotoSoundsServices {
    return NO;
}

+ (BOOL)gotoLocationServices {
    return NO;
}

+ (BOOL)gotoStorageAndBackupServices {
    return NO;
}

+ (BOOL)gotoStorageServices {
    return NO;
}

+ (BOOL)gotoNotesServices {
    return NO;
}

+ (BOOL)gotoPhoneServices {
    return NO;
}

+ (BOOL)gotoFaceTimeServices {
    return NO;
}

+ (BOOL)gotoMusicServices {
    return NO;
}

+ (BOOL)gotoPhotosServices {
    return NO;
}

+ (BOOL)p_iOS10OrLater {
    return ([[UIDevice currentDevice].systemVersion compare:@"10" options:NSNumericSearch] >= NSOrderedSame);
}
@end
