/*!
 *  @file SGSSystemUtil.h
 *
 *  @abstract 系统服务
 *
 *  @author Created by Lee on 16/9/2.
 *
 *  @copyright 2016年 SouthGIS. All rights reserved.
 */

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

/*!
 *  @abstract 系统服务工具类
 */
@interface SGSSystemUtil : NSObject

#pragma mark - 应用切换
///-----------------------------------------------------------------------------
/// @name 应用切换
///-----------------------------------------------------------------------------


/*!
 *  @abstract 应用切换
 *
 *  @param url        应用 URL Schemes
 *  @param options    切换参数，例如：@{UIApplicationOpenURLOptionUniversalLinksOnly : @YES}，
 *      传入空字典等同于调用 `-openURL:`
 *  @param completion 执行成功后在主队列中回调
 */
+ (void)openURL:(NSURL *)url
        options:(nullable NSDictionary<NSString *, id> *)options
completionHandler:(nullable void (^)(BOOL success))completion;

/*!
 *  @abstract 打开 Safari
 *
 *  @param url 网址
 *  @param options    切换参数，例如：@{UIApplicationOpenURLOptionUniversalLinksOnly : @YES}，
 *      传入空字典等同于调用 `-openURL:`
 *  @param completion 执行成功后在主队列中回调
 */
+ (void)openSafariWithURL:(NSURL *)url
                  options:(nullable NSDictionary<NSString *, id> *)options
        completionHandler:(nullable void (^)(BOOL success))completion;

/*!
 *  @abstract 打开QQ
 *
 *  @param options    切换参数，例如：@{UIApplicationOpenURLOptionUniversalLinksOnly : @YES}，
 *      传入空字典等同于调用 `-openURL:`
 *  @param completion 执行成功后在主队列中回调
 */
+ (void)openQQWithOptions:(nullable NSDictionary<NSString *, id> *)options
        completionHandler:(nullable void (^)(BOOL success))completion;

/*!
 *  @abstract 打开微信
 *
 *  @param options    切换参数，例如：@{UIApplicationOpenURLOptionUniversalLinksOnly : @YES}，
 *      传入空字典等同于调用 `-openURL:`
 *  @param completion 执行成功后在主队列中回调
 */
+ (void)openWeChatWithOptions:(nullable NSDictionary<NSString *, id> *)options completionHandler:(nullable void (^)(BOOL success))completion;

/*!
 *  @abstract 打开新浪微博
 *
 *  @param options    切换参数，例如：@{UIApplicationOpenURLOptionUniversalLinksOnly : @YES}，
 *      传入空字典等同于调用 `-openURL:`
 *  @param completion 执行成功后在主队列中回调
 */
+ (void)openSinaWeiboWithOptions:(nullable NSDictionary<NSString *, id> *)options
               completionHandler:(nullable void (^)(BOOL success))completion;

/*!
 *  @abstract 打开腾讯微博
 *
 *  @param options    切换参数，例如：@{UIApplicationOpenURLOptionUniversalLinksOnly : @YES}，
 *      传入空字典等同于调用 `-openURL:`
 *  @param completion 执行成功后在主队列中回调
 */
+ (void)openTencentWeiboWithOptions:(nullable NSDictionary<NSString *, id> *)options
                  completionHandler:(nullable void (^)(BOOL success))completion;

/*!
 *  @abstract 打开支付宝
 *
 *  @param options    切换参数，例如：@{UIApplicationOpenURLOptionUniversalLinksOnly : @YES}，
 *      传入空字典等同于调用 `-openURL:`
 *  @param completion 执行成功后在主队列中回调
 */
+ (void)openAlipayWithOptions:(nullable NSDictionary<NSString *, id> *)options
            completionHandler:(nullable void (^)(BOOL success))completion;

/*!
 *  @abstract 打开淘宝
 *
 *  @param options    切换参数，例如：@{UIApplicationOpenURLOptionUniversalLinksOnly : @YES}，
 *      传入空字典等同于调用 `-openURL:`
 *  @param completion 执行成功后在主队列中回调
 */
+ (void)openTaobaoWithOptions:(nullable NSDictionary<NSString *, id> *)options
            completionHandler:(nullable void (^)(BOOL success))completion;

/*!
 *  @abstract 打开天猫
 *
 *  @param options    切换参数，例如：@{UIApplicationOpenURLOptionUniversalLinksOnly : @YES}，
 *      传入空字典等同于调用 `-openURL:`
 *  @param completion 执行成功后在主队列中回调
 */
+ (void)openTmallWithOptions:(nullable NSDictionary<NSString *, id> *)options
           completionHandler:(nullable void (^)(BOOL success))completion;

/*!
 *  @abstract 打开手机京东
 *
 *  @param options    切换参数，例如：@{UIApplicationOpenURLOptionUniversalLinksOnly : @YES}，
 *      传入空字典等同于调用 `-openURL:`
 *  @param completion 执行成功后在主队列中回调
 */
+ (void)openJDWithOptions:(nullable NSDictionary<NSString *, id> *)options
        completionHandler:(nullable void (^)(BOOL success))completion;

/*!
 *  @abstract 打开iPad京东
 *
 *  @param options    切换参数，例如：@{UIApplicationOpenURLOptionUniversalLinksOnly : @YES}，
 *      传入空字典等同于调用 `-openURL:`
 *  @param completion 执行成功后在主队列中回调
 */
+ (void)openJDHDWithOptions:(nullable NSDictionary<NSString *, id> *)options
          completionHandler:(nullable void (^)(BOOL success))completion;

/*!
 *  @abstract 打开美团
 *
 *  @param options    切换参数，例如：@{UIApplicationOpenURLOptionUniversalLinksOnly : @YES}，
 *      传入空字典等同于调用 `-openURL:`
 *  @param completion 执行成功后在主队列中回调
 */
+ (void)openMeiTuanWithOptions:(nullable NSDictionary<NSString *, id> *)options
             completionHandler:(nullable void (^)(BOOL success))completion;

/*!
 *  @abstract 打开百度地图
 *
 *  @param options    切换参数，例如：@{UIApplicationOpenURLOptionUniversalLinksOnly : @YES}，
 *      传入空字典等同于调用 `-openURL:`
 *  @param completion 执行成功后在主队列中回调
 */
+ (void)openBaiduMapWithOptions:(nullable NSDictionary<NSString *, id> *)options
              completionHandler:(nullable void (^)(BOOL success))completion;

/*!
 *  @abstract 打开高德地图
 *
 *  @param options    切换参数，例如：@{UIApplicationOpenURLOptionUniversalLinksOnly : @YES}，
 *      传入空字典等同于调用 `-openURL:`
 *  @param completion 执行成功后在主队列中回调
 */
+ (void)openAMapWithOptions:(nullable NSDictionary<NSString *, id> *)options
          completionHandler:(nullable void (^)(BOOL success))completion;

/*!
 *  @abstract 打开腾讯地图
 *
 *  @param options    切换参数，例如：@{UIApplicationOpenURLOptionUniversalLinksOnly : @YES}，
 *      传入空字典等同于调用 `-openURL:`
 *  @param completion 执行成功后在主队列中回调
 */
+ (void)openSoSoMapWithOptions:(nullable NSDictionary<NSString *, id> *)options
             completionHandler:(nullable void (^)(BOOL success))completion;


#pragma mark - 系统服务
///-----------------------------------------------------------------------------
/// @name 系统服务
///-----------------------------------------------------------------------------

/*!
 *  @abstract 向指定的号码拨打电话
 *
 *  @param phone 电话号码
 *  @param completion 执行成功后在主队列中回调
 */
+ (void)callWithPhoneNumber:(NSString *)phone
          completionHandler:(nullable void (^)(BOOL success))completion;

/*!
 *  @abstract 向指定的号码发短信
 *
 *  @param phone 电话号码
 *  @param completion 执行成功后在主队列中回调
 */
+ (void)sendSMSWithPhoneNumber:(NSString *)phone
             completionHandler:(nullable void (^)(BOOL success))completion;

/*!
 *  @abstract 发送邮件
 *
 *  @param address 邮箱
 *  @param completion 执行成功后在主队列中回调
 */
+ (void)sendEmailToAddress:(NSString *)address
         completionHandler:(nullable void (^)(BOOL success))completion;

/*!
 *  @abstract 跳转到应用设置
 *
 *  @param completion 执行成功后在主队列中回调
 */
+ (void)gotoAppSettingWithCompletionHandler:(nullable void (^)(BOOL success))completion;

/*!
 *  @abstract 跳转到WIFI设置
 *
 *  @return `YES` 打开成功， `NO` 打开失败
 */
+ (BOOL)gotoWiFiServices NS_DEPRECATED_IOS(2_0, 10_0, "iOS 10.0 以后只能跳转到应用设置");

/*!
 *  @abstract 跳转到蜂窝网络设置
 *
 *  @return `YES` 打开成功， `NO` 打开失败
 */
+ (BOOL)gotoCellularServices NS_DEPRECATED_IOS(2_0, 10_0, "iOS 10.0 以后只能跳转到应用设置");

/*!
 *  @abstract 跳转到蓝牙设置
 *
 *  @return `YES` 打开成功， `NO` 打开失败
 */
+ (BOOL)gotoBluetoothServices NS_DEPRECATED_IOS(2_0, 10_0, "iOS 10.0 以后只能跳转到应用设置");

/*!
 *  @abstract 跳转到通知中心设置
 *
 *  @return `YES` 打开成功， `NO` 打开失败
 */
+ (BOOL)gotoNotificationsServices NS_DEPRECATED_IOS(2_0, 10_0, "iOS 10.0 以后只能跳转到应用设置");

/*!
 *  @abstract 跳转到系统通用设置
 *
 *  @return `YES` 打开成功， `NO` 打开失败
 */
+ (BOOL)gotoGeneralServices NS_DEPRECATED_IOS(2_0, 10_0, "iOS 10.0 以后只能跳转到应用设置");

/*!
 *  @abstract 跳转到关于本机设置
 *
 *  @return `YES` 打开成功， `NO` 打开失败
 */
+ (BOOL)gotoAboutServices NS_DEPRECATED_IOS(2_0, 10_0, "iOS 10.0 以后只能跳转到应用设置");

/*!
 *  @abstract 跳转到软件更新
 *
 *  @return `YES` 打开成功， `NO` 打开失败
 */
+ (BOOL)gotoSoftwareUpdateServices NS_DEPRECATED_IOS(2_0, 10_0, "iOS 10.0 以后只能跳转到应用设置");

/*!
 *  @abstract 跳转到SIRI设置
 *
 *  @return `YES` 打开成功， `NO` 打开失败
 */
+ (BOOL)gotoSiriServices NS_DEPRECATED_IOS(2_0, 10_0, "iOS 10.0 以后只能跳转到应用设置");

/*!
 *  @abstract 跳转到辅助功能设置
 *
 *  @return `YES` 打开成功， `NO` 打开失败
 */
+ (BOOL)gotoAccessibilityServices NS_DEPRECATED_IOS(2_0, 10_0, "iOS 10.0 以后只能跳转到应用设置");

/*!
 *  @abstract 跳转到自动锁定设置
 *
 *  @return `YES` 打开成功， `NO` 打开失败
 */
+ (BOOL)gotoAutoLockServices NS_DEPRECATED_IOS(2_0, 10_0, "iOS 10.0 以后只能跳转到应用设置");

/*!
 *  @abstract 跳转到日期与时间设置
 *
 *  @return `YES` 打开成功， `NO` 打开失败
 */
+ (BOOL)gotoDateAndTimeServices NS_DEPRECATED_IOS(2_0, 10_0, "iOS 10.0 以后只能跳转到应用设置");

/*!
 *  @abstract 跳转到键盘设置
 *
 *  @return `YES` 打开成功， `NO` 打开失败
 */
+ (BOOL)gotoKeyboardServices NS_DEPRECATED_IOS(2_0, 10_0, "iOS 10.0 以后只能跳转到应用设置");

/*!
 *  @abstract 跳转到语言与地区设置
 *
 *  @return `YES` 打开成功， `NO` 打开失败
 */
+ (BOOL)gotoInternationalServices NS_DEPRECATED_IOS(2_0, 10_0, "iOS 10.0 以后只能跳转到应用设置");

/*!
 *  @abstract 跳转到设备管理设置
 *
 *  @return `YES` 打开成功， `NO` 打开失败
 */
+ (BOOL)gotoManagedConfigurationServices NS_DEPRECATED_IOS(2_0, 10_0, "iOS 10.0 以后只能跳转到应用设置");

/*!
 *  @abstract 跳转到还原设置
 *
 *  @return `YES` 打开成功， `NO` 打开失败
 */
+ (BOOL)gotoResetServices NS_DEPRECATED_IOS(2_0, 10_0, "iOS 10.0 以后只能跳转到应用设置");

/*!
 *  @abstract 跳转到墙纸设置
 *
 *  @return `YES` 打开成功， `NO` 打开失败
 */
+ (BOOL)gotoWallpaperServices NS_DEPRECATED_IOS(2_0, 10_0, "iOS 10.0 以后只能跳转到应用设置");

/*!
 *  @abstract 跳转到声音设置
 *
 *  @return `YES` 打开成功， `NO` 打开失败
 */
+ (BOOL)gotoSoundsServices NS_DEPRECATED_IOS(2_0, 10_0, "iOS 10.0 以后只能跳转到应用设置");

/*!
 *  @abstract 跳转到定位服务
 *
 *  @return `YES` 打开成功， `NO` 打开失败
 */
+ (BOOL)gotoLocationServices NS_DEPRECATED_IOS(2_0, 10_0, "iOS 10.0 以后只能跳转到应用设置");

/*!
 *  @abstract 跳转到iCloud储存空间
 *
 *  @return `YES` 打开成功， `NO` 打开失败
 */
+ (BOOL)gotoStorageAndBackupServices NS_DEPRECATED_IOS(2_0, 10_0, "iOS 10.0 以后只能跳转到应用设置");

/*!
 *  @abstract 跳转到 iTunes Store 和 App Store 设置
 *
 *  @return `YES` 打开成功， `NO` 打开失败
 */
+ (BOOL)gotoStorageServices NS_DEPRECATED_IOS(2_0, 10_0, "iOS 10.0 以后只能跳转到应用设置");

/*!
 *  @abstract 跳转到备忘录设置
 *
 *  @return `YES` 打开成功， `NO` 打开失败
 */
+ (BOOL)gotoNotesServices NS_DEPRECATED_IOS(2_0, 10_0, "iOS 10.0 以后只能跳转到应用设置");

/*!
 *  @abstract 跳转到电话设置
 *
 *  @return `YES` 打开成功， `NO` 打开失败
 */
+ (BOOL)gotoPhoneServices NS_DEPRECATED_IOS(2_0, 10_0, "iOS 10.0 以后只能跳转到应用设置");

/*!
 *  @abstract 跳转到FaceTime设置
 *
 *  @return `YES` 打开成功， `NO` 打开失败
 */
+ (BOOL)gotoFaceTimeServices NS_DEPRECATED_IOS(2_0, 10_0, "iOS 10.0 以后只能跳转到应用设置");

/*!
 *  @abstract 跳转到音乐服务设置
 *
 *  @return `YES` 打开成功， `NO` 打开失败
 */
+ (BOOL)gotoMusicServices NS_DEPRECATED_IOS(2_0, 10_0, "iOS 10.0 以后只能跳转到应用设置");

/*!
 *  @abstract 跳转到照片与相机服务设置
 *
 *  @return `YES` 打开成功， `NO` 打开失败
 */
+ (BOOL)gotoPhotosServices NS_DEPRECATED_IOS(2_0, 10_0, "iOS 10.0 以后只能跳转到应用设置");

@end

NS_ASSUME_NONNULL_END
