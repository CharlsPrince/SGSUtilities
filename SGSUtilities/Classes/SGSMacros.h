/*!
 *  @file SGSMacros.h
 *
 *  @abstract 常用宏定义
 *
 *  @author Created by Lee on 16/4/20.
 *
 *  @copyright 2016年 SouthGIS. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <pthread.h>

#ifndef SGSMacros_h
#define SGSMacros_h


#pragma mark - 通用宏 Utilities Macros
///-----------------------------------------------------------------------------
/// @name 通用宏 Utilities Macros
///-----------------------------------------------------------------------------


/*!
 *  @brief 单例接口部分宏
 *
 *  @param class 单例的类
 */
#define SingletonInterface(class) + (instancetype)shared##class;


/*!
 *  @brief 单例实现部分宏
 *
 *  @param class 单例的类
 *
 *  @return 单例
 */
#define SingletonImplementation(class) \
static id _sharedInstance; \
\
+ (instancetype)shared##class { \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _sharedInstance = [[self alloc] init]; \
    }); \
    return _sharedInstance; \
} \
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone {\
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _sharedInstance = [super allocWithZone:zone]; \
    }); \
    return _sharedInstance; \
} \
\
- (id)copyWithZone:(NSZone *)zone { \
    return _sharedInstance; \
}

/*!
 *  @brief 懒加载宏
 *
 *  @param object     懒加载的属性
 *  @param assignment 懒加载属性为空时，需要执行的代码块
 *
 *  @return 懒加载属性
 */
#define Lazy(object, assignment...) ((object) = (object) ?: (assignment))


// 弱引用，搭配 strongify 使用
// 参照 Reactive Cocoa
// 用法：@weakify(self)
#ifndef    weakify
#if __has_feature(objc_arc)

#define weakify( x ) \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Wshadow\"") \
    autoreleasepool{} __weak __typeof__(x) __weak_##x##__   = x; \
    _Pragma("clang diagnostic pop")

#else

#define weakify( x ) \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Wshadow\"") \
    autoreleasepool{} __block __typeof__(x) __block_##x##__ = x; \
    _Pragma("clang diagnostic pop")

#endif
#endif


// 强引用，搭配 weakify 使用
// 参照 Reactive Cocoa
// 用法：@strongify(self)
#ifndef    strongify
#if __has_feature(objc_arc)

#define strongify( x ) \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Wshadow\"") \
    try{} @finally{} __typeof__(x) x = __weak_##x##__; \
    _Pragma("clang diagnostic pop")

#else

#define strongify( x ) \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Wshadow\"") \
    try{} @finally{} __typeof__(x) x = __block_##x##__; \
    _Pragma("clang diagnostic pop")

#endif
#endif



#pragma mark - 日志宏 Log Macros
///-----------------------------------------------------------------------------
/// @name 日志宏 Log Macros
///-----------------------------------------------------------------------------

/// debug 日志
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif


#pragma mark - 日内联函数 Inline Functions
///-----------------------------------------------------------------------------
/// @name 内联函数 Inline Functions
///-----------------------------------------------------------------------------


/*!
 *  @brief 内联函数，判断是否为空对象
 *
 *  @param obj 待判断的对象
 *
 *  @return `YES` 表示对象为 `nil` 或者是 `NSNull` , `NO` 表示非空对象
 */
static inline BOOL isNilOrNULL(id obj) {
    return ((obj == nil) || ([obj isEqual:[NSNull null]]));
}


/*!
 *  @brief 内联函数，角度转弧度
 *
 *  @param degrees 角度
 *
 *  @return 弧度
 */
static inline CGFloat degreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
}


/*!
 *  @brief 内联函数，弧度转角度
 *
 *  @param radians 弧度
 *
 *  @return 角度
 */
static inline CGFloat radiansToDegrees(CGFloat radians) {
    return radians * 180 / M_PI;
}

/*!
 *  @brief 内联函数，国际标准国家名称
 *
 *  @return 国家名称
 */
static inline NSArray<NSString *> * ISOCountryName() {
    static NSArray *result;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *countries = [[NSMutableArray alloc] init];
        NSLocale *locale = [NSLocale currentLocale];
        NSArray *countryCodes = [NSLocale ISOCountryCodes];
        
        for (NSString *countryCode in countryCodes) {
            NSString *displayName = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
            [countries addObject:displayName];
        }
        
        result = countries.copy;
    });
    
    return result;
}

/*!
 *  @brief 内联函数，在主线程中异步执行block
 *
 *  @discussion 如果当前线程为主线程，将会立即执行闭包而不是等到下一次RunLoop再执行
 *
 *  @param block 待执行的闭包
 */
static inline void dispatch_async_on_main_queue(void (^block)()) {
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}


/*!
 *  @brief 内联函数，在主线程中同步执行block
 *
 * @discussion 如果当前线程为主线程，将会立即执行闭包而不是等到下一次RunLoop再执行
 *
 *  @param block 待执行的闭包
 */
static inline void dispatch_sync_on_main_queue(void (^block)()) {
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

/*!
 *  @brief 内联函数，判断当前是否在主队列中
 *
 *  @return `YES` 在主队列， `NO` 不在主队列
 */
static inline BOOL isMainQueue() {
    static void *mainQueueKey = &mainQueueKey;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_queue_set_specific(dispatch_get_main_queue(), mainQueueKey, mainQueueKey, NULL);
    });
    return dispatch_get_specific(mainQueueKey) == mainQueueKey;
}

#endif /* SGSMacros_h */
