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
    NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];
    if ([self p_iOS10OrLater]) {
        return NO;
    } else {
        __block BOOL result = NO;
        [self openURL:url options:nil completionHandler:^(BOOL success) {
            result = success;
        }];
        return result;
    }
}

+ (BOOL)gotoCellularServices {
    NSURL *url = [NSURL URLWithString:@"prefs:root=MOBILE_DATA_SETTINGS_ID"];
    if ([self p_iOS10OrLater]) {
        return NO;
    } else {
        __block BOOL result = NO;
        [self openURL:url options:nil completionHandler:^(BOOL success) {
            result = success;
        }];
        return result;
    }
}

+ (BOOL)gotoBluetoothServices {
    NSURL *url = [NSURL URLWithString:@"prefs:root=Bluetooth"];
    if ([self p_iOS10OrLater]) {
        return NO;
    } else {
        __block BOOL result = NO;
        [self openURL:url options:nil completionHandler:^(BOOL success) {
            result = success;
        }];
        return result;
    }
}

+ (BOOL)gotoNotificationsServices {
    NSURL *url = [NSURL URLWithString:@"prefs:root=NOTIFICATIONS_ID"];
    if ([self p_iOS10OrLater]) {
        return NO;
    } else {
        __block BOOL result = NO;
        [self openURL:url options:nil completionHandler:^(BOOL success) {
            result = success;
        }];
        return result;
    }
}

+ (BOOL)gotoGeneralServices {
    NSURL *url = [NSURL URLWithString:@"prefs:root=General"];
    if ([self p_iOS10OrLater]) {
        return NO;
    } else {
        __block BOOL result = NO;
        [self openURL:url options:nil completionHandler:^(BOOL success) {
            result = success;
        }];
        return result;
    }
}

+ (BOOL)gotoAboutServices {
    NSURL *url = [NSURL URLWithString:@"prefs:root=General&path=About"];
    if ([self p_iOS10OrLater]) {
        return NO;
    } else {
        __block BOOL result = NO;
        [self openURL:url options:nil completionHandler:^(BOOL success) {
            result = success;
        }];
        return result;
    }
}

+ (BOOL)gotoSoftwareUpdateServices {
    NSURL *url = [NSURL URLWithString:@"prefs:root=General&path=SOFTWARE_UPDATE_LINK"];
    if ([self p_iOS10OrLater]) {
        return NO;
    } else {
        __block BOOL result = NO;
        [self openURL:url options:nil completionHandler:^(BOOL success) {
            result = success;
        }];
        return result;
    }
}

+ (BOOL)gotoSiriServices {
    NSURL *url = [NSURL URLWithString:@"prefs:root=General&path=SIRI"];
    if ([self p_iOS10OrLater]) {
        return NO;
    } else {
        __block BOOL result = NO;
        [self openURL:url options:nil completionHandler:^(BOOL success) {
            result = success;
        }];
        return result;
    }
}

+ (BOOL)gotoAccessibilityServices {
    NSURL *url = [NSURL URLWithString:@"prefs:root=General&path=ACCESSIBILITY"];
    if ([self p_iOS10OrLater]) {
        return NO;
    } else {
        __block BOOL result = NO;
        [self openURL:url options:nil completionHandler:^(BOOL success) {
            result = success;
        }];
        return result;
    }
}

+ (BOOL)gotoAutoLockServices {
    NSURL *url = [NSURL URLWithString:@"prefs:root=General&path=AUTOLOCK"];
    if ([self p_iOS10OrLater]) {
        return NO;
    } else {
        __block BOOL result = NO;
        [self openURL:url options:nil completionHandler:^(BOOL success) {
            result = success;
        }];
        return result;
    }
}

+ (BOOL)gotoDateAndTimeServices {
    NSURL *url = [NSURL URLWithString:@"prefs:root=General&path=DATE_AND_TIME"];
    if ([self p_iOS10OrLater]) {
        return NO;
    } else {
        __block BOOL result = NO;
        [self openURL:url options:nil completionHandler:^(BOOL success) {
            result = success;
        }];
        return result;
    }
}

+ (BOOL)gotoKeyboardServices {
    NSURL *url = [NSURL URLWithString:@"prefs:root=General&path=Keyboard"];
    if ([self p_iOS10OrLater]) {
        return NO;
    } else {
        __block BOOL result = NO;
        [self openURL:url options:nil completionHandler:^(BOOL success) {
            result = success;
        }];
        return result;
    }
}

+ (BOOL)gotoInternationalServices {
    NSURL *url = [NSURL URLWithString:@"prefs:root=General&path=INTERNATIONAL"];
    if ([self p_iOS10OrLater]) {
        return NO;
    } else {
        __block BOOL result = NO;
        [self openURL:url options:nil completionHandler:^(BOOL success) {
            result = success;
        }];
        return result;
    }
}

+ (BOOL)gotoManagedConfigurationServices {
    NSURL *url = [NSURL URLWithString:@"prefs:root=General&path=ManagedConfigurationList"];
    if ([self p_iOS10OrLater]) {
        return NO;
    } else {
        __block BOOL result = NO;
        [self openURL:url options:nil completionHandler:^(BOOL success) {
            result = success;
        }];
        return result;
    }
}

+ (BOOL)gotoResetServices {
    NSURL *url = [NSURL URLWithString:@"prefs:root=General&path=Reset"];
    if ([self p_iOS10OrLater]) {
        return NO;
    } else {
        __block BOOL result = NO;
        [self openURL:url options:nil completionHandler:^(BOOL success) {
            result = success;
        }];
        return result;
    }
}

+ (BOOL)gotoWallpaperServices {
    NSURL *url = [NSURL URLWithString:@"prefs:root=Wallpaper"];
    if ([self p_iOS10OrLater]) {
        return NO;
    } else {
        __block BOOL result = NO;
        [self openURL:url options:nil completionHandler:^(BOOL success) {
            result = success;
        }];
        return result;
    }
}

+ (BOOL)gotoSoundsServices {
    NSURL *url = [NSURL URLWithString:@"prefs:root=Sounds"];
    if ([self p_iOS10OrLater]) {
        return NO;
    } else {
        __block BOOL result = NO;
        [self openURL:url options:nil completionHandler:^(BOOL success) {
            result = success;
        }];
        return result;
    }
}

+ (BOOL)gotoLocationServices {
    NSURL *url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
    if ([self p_iOS10OrLater]) {
        return NO;
    } else {
        __block BOOL result = NO;
        [self openURL:url options:nil completionHandler:^(BOOL success) {
            result = success;
        }];
        return result;
    }
}

+ (BOOL)gotoStorageAndBackupServices {
    NSURL *url = [NSURL URLWithString:@"prefs:root=CASTLE&path=STORAGE_AND_BACKUP"];
    if ([self p_iOS10OrLater]) {
        return NO;
    } else {
        __block BOOL result = NO;
        [self openURL:url options:nil completionHandler:^(BOOL success) {
            result = success;
        }];
        return result;
    }
}

+ (BOOL)gotoStorageServices {
    NSURL *url = [NSURL URLWithString:@"prefs:root=STORE"];
    if ([self p_iOS10OrLater]) {
        return NO;
    } else {
        __block BOOL result = NO;
        [self openURL:url options:nil completionHandler:^(BOOL success) {
            result = success;
        }];
        return result;
    }
}

+ (BOOL)gotoNotesServices {
    NSURL *url = [NSURL URLWithString:@"prefs:root=NOTES"];
    if ([self p_iOS10OrLater]) {
        return NO;
    } else {
        __block BOOL result = NO;
        [self openURL:url options:nil completionHandler:^(BOOL success) {
            result = success;
        }];
        return result;
    }
}

+ (BOOL)gotoPhoneServices {
    NSURL *url = [NSURL URLWithString:@"prefs:root=Phone"];
    if ([self p_iOS10OrLater]) {
        return NO;
    } else {
        __block BOOL result = NO;
        [self openURL:url options:nil completionHandler:^(BOOL success) {
            result = success;
        }];
        return result;
    }
}

+ (BOOL)gotoFaceTimeServices {
    NSURL *url = [NSURL URLWithString:@"prefs:root=FACETIME"];
    if ([self p_iOS10OrLater]) {
        return NO;
    } else {
        __block BOOL result = NO;
        [self openURL:url options:nil completionHandler:^(BOOL success) {
            result = success;
        }];
        return result;
    }
}

+ (BOOL)gotoMusicServices {
    NSURL *url = [NSURL URLWithString:@"prefs:root=MUSIC"];
    if ([self p_iOS10OrLater]) {
        return NO;
    } else {
        __block BOOL result = NO;
        [self openURL:url options:nil completionHandler:^(BOOL success) {
            result = success;
        }];
        return result;
    }
}

+ (BOOL)gotoPhotosServices {
    NSURL *url = [NSURL URLWithString:@"prefs:root=Photos"];
    if ([self p_iOS10OrLater]) {
        return NO;
    } else {
        __block BOOL result = NO;
        [self openURL:url options:nil completionHandler:^(BOOL success) {
            result = success;
        }];
        return result;
    }
}

+ (BOOL)p_iOS10OrLater {
    return ([[UIDevice currentDevice].systemVersion compare:@"10" options:NSNumericSearch] >= NSOrderedSame);
}
@end
