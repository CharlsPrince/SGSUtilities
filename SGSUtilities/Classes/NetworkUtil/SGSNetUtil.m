/*!
 *  @file SGSNetUtil.m
 *
 *  @author Created by Lee on 16/9/2.
 *
 *  @copyright 2016年 SouthGIS. All rights reserved.
 */

#import "SGSNetUtil.h"
#include <sys/socket.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <pthread/pthread.h>
@import SystemConfiguration.SCNetworkReachability;
@import CoreTelephony.CTTelephonyNetworkInfo;

NSString * const SGSNetReachabilityDidChangedNotification = @"com.southgis.iMobile.netReachability.didChangeNotification";

NSString * const SGSNetReachabilityNotificationStatusKey = @"SGSNetReachabilityNotificationStatus";

/// 获取网络连接标志
static SCNetworkReachabilityFlags p_networkReachabilityFlags() {
    // 创建零地址表示查询本机的网络连接状态
    struct sockaddr_storage zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.ss_len = sizeof(zeroAddress);
    zeroAddress.ss_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    // 获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    return didRetrieveFlags ? flags : 0;
}

/// 2G网络
static NSSet * p_WWAN2G() {
    static NSSet *WWAN2G;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        WWAN2G = [NSSet setWithArray:@[CTRadioAccessTechnologyEdge,
                                       CTRadioAccessTechnologyGPRS,
                                       CTRadioAccessTechnologyCDMA1x]];
    });
    
    return WWAN2G;
}

/// 3G网络
static NSSet * p_WWAN3G() {
    static NSSet * WWAN3G;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        WWAN3G = [NSSet setWithArray:@[CTRadioAccessTechnologyHSDPA,
                                       CTRadioAccessTechnologyWCDMA,
                                       CTRadioAccessTechnologyHSUPA,
                                       CTRadioAccessTechnologyCDMAEVDORev0,
                                       CTRadioAccessTechnologyCDMAEVDORevA,
                                       CTRadioAccessTechnologyCDMAEVDORevB,
                                       CTRadioAccessTechnologyeHRPD]];
    });
    
    return WWAN3G;
}

/// 4G网络
static NSSet * p_WWAN4G() {
    static NSSet *WWAN4G;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        WWAN4G = [NSSet setWithObject:CTRadioAccessTechnologyLTE];
    });
    
    return WWAN4G;
}

/// 判断网络状态
static SGSNetworkStatus p_networkStatusForFlags(SCNetworkReachabilityFlags flags) {
    if (flags == 0) return SGSNetworkStatusNotReachable;
    
    BOOL isReachable = ((flags & kSCNetworkReachabilityFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkReachabilityFlagsConnectionRequired) != 0);
    BOOL canConnectionAutomatically = (((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) || ((flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0));
    BOOL canConnectWithoutUserInteraction = (canConnectionAutomatically && (flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0);
    BOOL isNetworkReachable = (isReachable && (!needsConnection || canConnectWithoutUserInteraction));
    
    SGSNetworkStatus status = SGSNetworkStatusUnknown;
    if (isNetworkReachable == NO) {
        status = SGSNetworkStatusNotReachable;
    } else if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN) {
        
        CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
        NSString *access = info.currentRadioAccessTechnology;
        
        if ([p_WWAN4G() containsObject:access]) {
            status = SGSNetworkStatusReachableViaWWAN4G;
        } else if ([p_WWAN3G() containsObject:access]) {
            status = SGSNetworkStatusReachableViaWWAN3G;
        } else if ([p_WWAN2G() containsObject:access]) {
            status = SGSNetworkStatusReachableViaWWAN2G;
        }

    } else {
        status = SGSNetworkStatusReachableViaWiFi;
    }
    
    return status;
}

/// 发送网络状态变化通知
static void p_postReachabilityChangedNotification(SGSNetworkStatus status, id obj) {
    if (pthread_main_np()) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SGSNetReachabilityDidChangedNotification object:obj userInfo:@{SGSNetReachabilityNotificationStatusKey: @(status)}];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:SGSNetReachabilityDidChangedNotification object:obj userInfo:@{SGSNetReachabilityNotificationStatusKey: @(status)}];
        });
    }
}

/// 网络状态变化回调方法
static void p_networkReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info) {
#pragma unused (target)
    NSCAssert(info != NULL, @"info was NULL in ReachabilityCallback");
    
    SGSNetworkStatus status = p_networkStatusForFlags(flags);
    SGSNetUtil *noteObject = (__bridge SGSNetUtil *)info;
    [noteObject setValue:@(status) forKey:@"networkReachabilityStatus"];
    
    p_postReachabilityChangedNotification(status, noteObject);
}

#pragma mark -

@interface SGSNetUtil ()
@property (nonatomic, assign, readwrite) SGSNetworkStatus networkReachabilityStatus;
@end

@implementation SGSNetUtil {
    SCNetworkReachabilityRef _reachabilityRef;
}

+ (instancetype)sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self networkReachabilityForInternetConnection];
    });
    return instance;
}

+ (instancetype)networkReachabilityWithHostName:(NSString *)hostName {
    SGSNetUtil *result = nil;
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, hostName.UTF8String);
    if (reachability != NULL) {
        result = [[self alloc] init];
        if (result != nil) {
            result->_reachabilityRef = reachability;
            result.networkReachabilityStatus = SGSNetworkStatusUnknown;
        } else {
            CFRelease(reachability);
        }
    }
    
    return result;
}

+ (instancetype)networkReachabilityWithAddress:(const struct sockaddr *)hostAddress {
    SGSNetUtil *result = nil;
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, hostAddress);
    if (reachability != NULL) {
        result = [[self alloc] init];
        if (result != nil) {
            result->_reachabilityRef = reachability;
            result.networkReachabilityStatus = SGSNetworkStatusUnknown;
        } else {
            CFRelease(reachability);
        }
    }
    
    return result;
}

+ (instancetype)networkReachabilityForInternetConnection {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    return [self networkReachabilityWithAddress: (const struct sockaddr *) &zeroAddress];
}

- (void)dealloc {
    [self stopMonitoring];
    if (_reachabilityRef != NULL) {
        CFRelease(_reachabilityRef);
    }
}

#pragma mark - getter 

- (BOOL)isReachable {
    return ([self isReachableViaWiFi] || [self isReachableViaWWAN]);
}

- (BOOL)isReachableViaWiFi {
    return (self.networkReachabilityStatus == SGSNetworkStatusReachableViaWiFi);
}

- (BOOL)isReachableViaWWAN {
    SGSNetworkStatus status = self.networkReachabilityStatus;
    
    return ((status == SGSNetworkStatusReachableViaWWAN4G) ||
            (status == SGSNetworkStatusReachableViaWWAN3G) ||
            (status == SGSNetworkStatusReachableViaWWAN2G));
}

- (BOOL)isReachableViaWWAN2G {
    return (self.networkReachabilityStatus == SGSNetworkStatusReachableViaWWAN2G);
}

- (BOOL)isReachableViaWWAN3G {
    return (self.networkReachabilityStatus == SGSNetworkStatusReachableViaWWAN3G);
}

- (BOOL)isReachableViaWWAN4G {
    return (self.networkReachabilityStatus == SGSNetworkStatusReachableViaWWAN4G);
}

#pragma mark - 

- (BOOL)startMonitoring {
    [self stopMonitoring];
    
    BOOL result = NO;
    SCNetworkReachabilityContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    
    if (SCNetworkReachabilitySetCallback(_reachabilityRef, p_networkReachabilityCallback, &context)) {
        if (SCNetworkReachabilityScheduleWithRunLoop(_reachabilityRef, CFRunLoopGetMain(), kCFRunLoopCommonModes)) {
            
            result = YES;
            
            __weak __typeof(self)weakSelf = self;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                SCNetworkReachabilityFlags flags;
                if (SCNetworkReachabilityGetFlags(self->_reachabilityRef, &flags)) {
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    
                    SGSNetworkStatus status = p_networkStatusForFlags(flags);
                    strongSelf.networkReachabilityStatus = status;
                    p_postReachabilityChangedNotification(status, strongSelf);
                }
            });
        }
    }
    
    return result;
}

- (void)stopMonitoring {
    if (_reachabilityRef != NULL) {
        SCNetworkReachabilityUnscheduleFromRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    }
}

- (NSString *)localizedNetworkReachabilityStatusString {
    switch (self.networkReachabilityStatus) {
        case SGSNetworkStatusNotReachable:
            return NSLocalizedString(@"NotReachable", nil);
        case SGSNetworkStatusReachableViaWiFi:
            return NSLocalizedString(@"WiFi", nil);
        case SGSNetworkStatusReachableViaWWAN2G:
            return NSLocalizedString(@"WWAN2G", nil);
        case SGSNetworkStatusReachableViaWWAN3G:
            return NSLocalizedString(@"WWAN3G", nil);
        case SGSNetworkStatusReachableViaWWAN4G:
            return NSLocalizedString(@"WWAN4G", nil);
        case SGSNetworkStatusUnknown:
        default:
            return NSLocalizedString(@"Unknown", nil);
    }
}

#pragma mark - 网络状态

+ (BOOL)isReachable {
    SCNetworkReachabilityFlags flags = p_networkReachabilityFlags();
    SGSNetworkStatus status = p_networkStatusForFlags(flags);
    
    return ((status != SGSNetworkStatusNotReachable) &&
            (status != SGSNetworkStatusUnknown));
}

+ (BOOL)isReachableViaWiFi {
    SCNetworkReachabilityFlags flags = p_networkReachabilityFlags();
    SGSNetworkStatus status = p_networkStatusForFlags(flags);
    
    return (status == SGSNetworkStatusReachableViaWiFi);
}

+ (BOOL)isReachableViaWWAN {
    SCNetworkReachabilityFlags flags = p_networkReachabilityFlags();
    SGSNetworkStatus status = p_networkStatusForFlags(flags);
    
    return ((status == SGSNetworkStatusReachableViaWWAN4G) ||
            (status == SGSNetworkStatusReachableViaWWAN3G) ||
            (status == SGSNetworkStatusReachableViaWWAN2G));
}

+ (BOOL)isReachableViaWWAN2G {
    SCNetworkReachabilityFlags flags = p_networkReachabilityFlags();
    SGSNetworkStatus status = p_networkStatusForFlags(flags);
    
    return (status == SGSNetworkStatusReachableViaWWAN2G);
}

+ (BOOL)isReachableViaWWAN3G {
    SCNetworkReachabilityFlags flags = p_networkReachabilityFlags();
    SGSNetworkStatus status = p_networkStatusForFlags(flags);
    
    return (status == SGSNetworkStatusReachableViaWWAN3G);
}

+ (BOOL)isReachableViaWWAN4G {
    SCNetworkReachabilityFlags flags = p_networkReachabilityFlags();
    SGSNetworkStatus status = p_networkStatusForFlags(flags);
    
    return (status == SGSNetworkStatusReachableViaWWAN4G);
}

#pragma mark - ip 地址

+ (NSString *)ipAddress {
    SCNetworkReachabilityFlags flags = p_networkReachabilityFlags();
    SGSNetworkStatus status = p_networkStatusForFlags(flags);
    
    if (status == SGSNetworkStatusReachableViaWiFi) {
        return [self ipAddressForWiFi];
    }
    
    if ((status == SGSNetworkStatusReachableViaWWAN4G) ||
        (status == SGSNetworkStatusReachableViaWWAN3G) ||
        (status == SGSNetworkStatusReachableViaWWAN2G)) {
        return [self ipAddressForWWAN];
    }
    
    return nil;
}

+ (NSString *)ipAddressForWiFi {
    NSString *address = nil;
    struct ifaddrs *addrs = NULL;
    if (getifaddrs(&addrs) == 0) {
        struct ifaddrs *addr = addrs;
        while (addr != NULL) {
            if (addr->ifa_addr->sa_family == AF_INET) {
                if ([[NSString stringWithUTF8String:addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:
                               inet_ntoa(((struct sockaddr_in *)addr->ifa_addr)->sin_addr)];
                    break;
                }
            }
            addr = addr->ifa_next;
        }
    }
    freeifaddrs(addrs);
    
    return address;
}

+ (NSString *)ipAddressForWWAN {
    NSString *address = nil;
    struct ifaddrs *addrs = NULL;
    if (getifaddrs(&addrs) == 0) {
        struct ifaddrs *addr = addrs;
        while (addr != NULL) {
            if (addr->ifa_addr->sa_family == AF_INET) {
                if ([[NSString stringWithUTF8String:addr->ifa_name] isEqualToString:@"pdp_ip0"]) {
                    address = [NSString stringWithUTF8String:
                               inet_ntoa(((struct sockaddr_in *)addr->ifa_addr)->sin_addr)];
                    break;
                }
            }
            addr = addr->ifa_next;
        }
    }
    freeifaddrs(addrs);
    
    return address;
}

@end
