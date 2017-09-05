/*!
 *  @file SGSNetUtil.h
 *
 *  @abstract 网络状态工具类
 *
 *  @author Created by Lee on 16/9/2.
 *
 *  @copyright 2016年 SouthGIS. All rights reserved.
 */

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/*!
 *  @abstract 网络状态
 */
typedef NS_ENUM(NSInteger, SGSNetworkStatus) {
    SGSNetworkStatusUnknown            = -1, //! 未知网络
    SGSNetworkStatusNotReachable       = 0,  //! 无网络状态
    SGSNetworkStatusReachableViaWiFi   = 1,  //! WiFi
    SGSNetworkStatusReachableViaWWAN2G = 2,  //! 2G蜂窝网络
    SGSNetworkStatusReachableViaWWAN3G = 3,  //! 3G蜂窝网络
    SGSNetworkStatusReachableViaWWAN4G = 4,  //! 4G蜂窝网络
};

/*!
 *  @abstract 网络状态工具类
 *
 *  @see https://developer.apple.com/library/ios/samplecode/reachability/
 */
@interface SGSNetUtil : NSObject

#pragma mark - 网络状态监测
///-----------------------------------------------------------------------------
/// @name 网络状态监测
///-----------------------------------------------------------------------------

/*!
 *  @abstract 当前网络状态
 */
@property (nonatomic, assign, readonly) SGSNetworkStatus networkReachabilityStatus;

/*!
 *  @abstract 判断当前是否连接到网络
 */
@property (nonatomic, assign, readonly, getter = isReachable) BOOL reachable;

/*!
 *  @abstract 判断当前是否连接到 WiFi
 */
@property (nonatomic, assign, readonly, getter = isReachableViaWiFi) BOOL reachableViaWiFi;

/*!
 *  @abstract 判断当前是否连接到蜂窝网络
 */
@property (nonatomic, assign, readonly, getter = isReachableViaWWAN) BOOL reachableViaWWAN;

/*!
 *  @abstract 判断当前是否连接到2G蜂窝网络
 */
@property (nonatomic, assign, readonly, getter = isReachableViaWWAN2G) BOOL reachableViaWWAN2G;

/*!
 *  @abstract 判断当前是否连接到3G蜂窝网络
 */
@property (nonatomic, assign, readonly, getter = isReachableViaWWAN3G) BOOL reachableViaWWAN3G;

/*!
 *  @abstract 判断当前是否连接到4G蜂窝网络
 */
@property (nonatomic, assign, readonly, getter = isReachableViaWWAN4G) BOOL reachableViaWWAN4G;

/*!
 *  @abstract 单例
 *
 *  @discussion 将采用 `+networkReachabilityForInternetConnection` 的方式初始化
 *
 *  @return 单例
 */
+ (instancetype)sharedInstance;

/*!
 *  @abstract 用于检测是否能连通给定的主机名
 *
 *  @param hostName 主机名
 *
 *  @return 网络检测实例
 */
+ (nullable instancetype)networkReachabilityWithHostName:(NSString *)hostName;


/*!
 *  @abstract 用于检测是否能连通给定的 IP 地址
 *
 *  @param hostAddress IP 地址
 *
 *  @return 网络检测实例
 */
+ (nullable instancetype)networkReachabilityWithAddress:(const struct sockaddr *)hostAddress;


/*!
 *  @abstract 用于检测是否连接到网络
 *
 *  @return 网络检测实例
 */
+ (instancetype)networkReachabilityForInternetConnection;


/*!
 *  @abstract 开始监听网络，需要先实例化网络检测实例
 *
 *  @return `YES` 开始监听； `NO` 监听失败
 */
- (BOOL)startMonitoring;


/*!
 *  @abstract 停止监听网络
 */
- (void)stopMonitoring;


/*!
 *  @abstract 网络状态本地化描述
 *
 *  @return 网络状态描述
 */
- (NSString *)localizedNetworkReachabilityStatusString;


#pragma mark - 静态网络状态
///-----------------------------------------------------------------------------
/// @name 静态网络状态
///-----------------------------------------------------------------------------

/*!
 *  @abstract 判断是否连接到网络，不需要开启网络监听
 *
 *  @discussion 该方法只能判断设备是否已经连接到网络，并不能判断是否能上网
 *
 *  例如连接到了不能上网的 WIFI 设备，该方法将返回 `YES` 但是手机是不能上网的
 *
 *  @return `YES` 当前设备已连网； `NO` 当前设备处于无网络状态
 */
+ (BOOL)isReachable;

/*!
 *  @abstract 判断是否连接到 WiFi，不需要开启网络监听
 *
 *  @return `YES` 当前设备连接到 WiFi 环境； `NO` 当前设备没有连接到 WiFi
 */
+ (BOOL)isReachableViaWiFi;

/*!
 *  @abstract 判断是否使用蜂窝网络，不需要开启网络监听
 *
 *  @return `YES` 当前设备正在使用蜂窝网络； `NO` 当前设备没有使用蜂窝网络
 */
+ (BOOL)isReachableViaWWAN;

/*!
 *  @abstract 判断是否使用2G蜂窝网络，不需要开启网络监听
 *
 *  @return `YES` 当前设备正在使用2G蜂窝网络； `NO` 当前设备没有使用2G蜂窝网络
 */
+ (BOOL)isReachableViaWWAN2G;

/*!
 *  @abstract 判断是否使用3G蜂窝网络，不需要开启网络监听
 *
 *  @return `YES` 当前设备正在使用3G蜂窝网络； `NO` 当前设备没有使用3G蜂窝网络
 */
+ (BOOL)isReachableViaWWAN3G;

/*!
 *  @abstract 判断是否使用4G蜂窝网络，不需要开启网络监听
 *
 *  @return `YES` 当前设备正在使用4G蜂窝网络； `NO` 当前设备没有使用4G蜂窝网络
 */
+ (BOOL)isReachableViaWWAN4G;


#pragma mark - IP 地址
///-----------------------------------------------------------------------------
/// @name IP 地址
///-----------------------------------------------------------------------------

/*!
 *  @abstract IP 地址
 *
 *  @discussion 根据所处网络环境不同而返回不同的 IP 地址:
 *      1. WiFi: 如果处于 WiFi 环境那么优先返回局域网地址
 *      2. WWAN: 如果使用蜂窝网络，那么返回无线广域网地址
 *      3. Unknown or NotReachable: 返回 `nil`
 *
 *  @return IP 地址
 */
+ (nullable NSString *)ipAddress;


/*!
 *  @abstract WiFi 的 IP 地址
 *
 *  @return 例如："192.168.1.100"，如果当前不是 WiFi 环境将返回 `nil`
 */
+ (nullable NSString *)ipAddressForWiFi;


/*!
 *  @abstract 无线广域网的 IP 地址
 *
 *  @return 例如："10.10.127.55"，如果当前不是蜂窝网络将返回 `nil`
 */
+ (nullable NSString *)ipAddressForWWAN;

@end


/*!
 *  @abstract 网络状态变化通知
 */
FOUNDATION_EXPORT NSString * const SGSNetReachabilityDidChangedNotification;

/*!
 *  @abstract 网络状态变化通知 userInfo 携带信息的 key
 */
FOUNDATION_EXPORT NSString * const SGSNetReachabilityNotificationStatusKey;

NS_ASSUME_NONNULL_END
