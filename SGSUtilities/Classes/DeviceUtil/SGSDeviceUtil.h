/*!
 *  @file SGSDeviceUtil.h
 *
 *  @abstract 设备相关便捷方法
 *
 *  @author Created by Lee on 16/9/2.
 *
 *  @copyright 2016年 SouthGIS. All rights reserved.
 */

@import Foundation;
@import CoreGraphics;

NS_ASSUME_NONNULL_BEGIN

/*!
 *  设备信息工具类
 */
@interface SGSDeviceUtil : NSObject

#pragma mark - 屏幕
///-----------------------------------------------------------------------------
/// @name 屏幕
///-----------------------------------------------------------------------------

/*!
 *  @abstract 屏幕等级
 *
 *  @return 非Retina屏为1，6Plus/6Plus+为3，其余为2
 */
+ (CGFloat)screenScale;

/*!
 *  @abstract 竖屏的屏幕大小
 *
 *  @return 屏幕尺寸
 */
+ (CGSize)screenSize;

/*!
 *  @abstract 屏幕宽度
 *
 *  @return 屏幕宽度
 */
+ (CGFloat)screenWidth;

/*!
 *  @abstract 屏幕高度
 *
 *  @return 屏幕高度
 */
+ (CGFloat)screenHeight;

/*!
 *  @abstract 屏幕分辨率
 *
 *  @return pixel
 */
+ (CGSize)sizeInPixel;

/*!
 *  @abstract 屏幕像素
 *
 *  @return PPI
 */
+ (CGFloat)pixelsPerInch;

/*!
 *  @abstract 当前屏幕范围
 *
 *  @discussion 根据横屏或竖屏不同，范围将有所改变
 *
 *  @return 屏幕范围
 */
+ (CGRect)currentScreenBounds;

/*!
 *  @abstract 判断当前是否为竖屏
 *
 *  @return `YES` 竖屏； `NO` 横屏
 */
+ (BOOL)isPortrait;

/*!
 *  @abstract 判断当前是否为横屏
 *
 *  @return `YES` 横屏； `NO` 竖屏
 */
+ (BOOL)isLandscape;


#pragma mark - 设备基本信息与系统版本
///-----------------------------------------------------------------------------
/// @name 设备基本信息与系统版本
///-----------------------------------------------------------------------------

/*!
 *  @abstract 通用唯一识别码
 *
 *  @return UUID
 */
+ (NSString *)UUID;

/*!
 *  @abstract 设备名称，例如："My iPhone"
 *
 *  @return 设备名字符串
 */
+ (NSString *)deviceName;

/*!
 *  @abstract 系统名称，例如："iOS"
 *
 *  @return 系统名字符串
 */
+ (NSString *)systemName;

/*!
 *  @abstract 设备型号，例如：iPhone8,4
 *
 *  @return 设备型号
 */
+ (NSString *)machineModel;

/*!
 *  @abstract 设备型号名称，例如：iPhone SE
 *
 *  @return 设备型号名称
 */
+ (NSString *)machineModelName;

/*!
 *  @abstract 系统版本，例如：9.3.5
 *
 *  @return 系统版本
 */
+ (NSString *)systemVersion;

/*!
 *  @abstract 系统版本数值，例如：9.3
 *
 *  @return 系统版本
 */
+ (float)systemVersionNumber;

/*!
 *  @abstract 判断当前系统版本是否大于等于 iOS 7.0
 *
 *  @return `YES` 7.0 及其以上版本； `NO` 低于 7.0
 */
+ (BOOL)iOS7OrLater;


/*!
 *  @abstract 判断当前系统版本是否大于等于 iOS 8.0
 *
 *  @return `YES` 8.0 及其以上版本； `NO` 低于 8.0
 */
+ (BOOL)iOS8OrLater;

/*!
 *  @abstract 判断当前系统版本是否大于等于 iOS 9.0
 *
 *  @return `YES` 9.0 及其以上版本； `NO` 低于 9.0
 */
+ (BOOL)iOS9OrLater;

/*!
 *  @abstract 判断当前系统版本是否大于等于 iOS 10.0
 *
 *  @return `YES` 10.0 及其以上版本； `NO` 低于 10.0
 */
+ (BOOL)iOS10OrLater;

/*!
 *  @abstract 判断系统版本是否等于给定的版本
 *
 *  @param version 给定的版本
 *
 *  @return `YES` 等于； `NO` 不等于
 */
+ (BOOL)systemVersionEqualTo:(float)version;


/*!
 *  @abstract 判断系统版本是否大于给定的版本
 *
 *  @param version 给定的版本，例如：@"9", @"9.0", @"9.3", @"9.3.1"
 *
 *  @return `YES` 大于； `NO` 小于等于
 */
+ (BOOL)systemVersionGreaterThan:(NSString *)version;


/*!
 *  @abstract 判断系统版本是否大于等于给定的版本
 *
 *  @param version 给定的版本，例如：@"9", @"9.0", @"9.3", @"9.3.1"
 *
 *  @return `YES` 大于等于； `NO` 小于
 */
+ (BOOL)systemVersionGreaterThanOrEqualTo:(NSString *)version;

/*!
 *  @abstract 判断系统版本是否小于给定的版本
 *
 *  @param version 给定的版本，例如：@"9", @"9.0", @"9.3", @"9.3.1"
 *
 *  @return `YES` 小于； `NO` 大于等于
 */
+ (BOOL)systemVersionLessThan:(NSString *)version;

/*!
 *  @abstract 判断系统版本是否小于等于给定的版本
 *
 *  @param version 给定的版本，例如：@"9", @"9.0", @"9.3", @"9.3.1"
 *
 *  @return `YES` 小于等于； `NO` 大于
 */
+ (BOOL)systemVersionLessThanOrEqualTo:(NSString *)version;

/*!
 *  @abstract 当前系统设置的国家，例如（中国）
 *
 *  @return 国家
 */
+ (NSString *)localeCountry;

/*!
 *  @abstract 当前国家区号，例如：CN
 *
 *  @return 国家区号
 */
+ (NSString *)localeCountryCode;

/*!
 *  @abstract 当前设备所支持的语言环境
 *
 *  @return 支持的语言环境
 */
+ (NSArray<__kindof NSString *> *)deviceLanguageCodes;

/*!
 *  @abstract 当前设备的首选语言代码，例如：zh-Hans-CN
 *
 *  @return 首选语言代码
 */
+ (NSString *)preferredLanguageCode;

/*!
 *  @abstract 当前设备的首选语言，例如（简体中文）
 *
 *  @return 首选语言
 */
+ (NSString *)preferredLanguage;

/*!
 *  @abstract 获取运营商名称，例如：中国联通
 *
 *  @return 运营商名称
 */
+ (nullable NSString *)carrierName;


#pragma mark - 磁盘空间
///-----------------------------------------------------------------------------
/// @name 磁盘空间
///-----------------------------------------------------------------------------

/*!
 *  @abstract 系统磁盘总大小（单位：字节/Byte）
 *
 *  @return 磁盘总大小，如果获取失败返回 `-1`
 */
+ (int64_t)diskSpaceTotal;

/*!
 *  @abstract 系统可用磁盘大小（单位：字节/Byte）
 *
 *  @return 磁盘剩余空间，如果获取失败返回 `-1`
 */
+ (int64_t)diskSpaceFree;

/*!
 *  @abstract 系统磁盘已使用空间（单位：字节/Byte）
 *
 *  @discussion 根据 `diskSpace` 和 `diskSpaceFree` 计算得到
 *
 *  @return 磁盘已使用空间，如果获取失败返回 `-1`
 */
+ (int64_t)diskSpaceUsed;

#pragma mark - 内存状况
///-----------------------------------------------------------------------------
/// @name 内存状况
///-----------------------------------------------------------------------------

/*!
 *  @abstract 物理内存总大小（单位：字节/Byte）
 *
 *  @return 物理内存总大小，如果获取失败返回 `-1`
 */
+ (int64_t)memoryTotal;

/*!
 *  @abstract 可用内存大小（单位：字节/Byte）
 *
 *  @discussion 在真机中 memoryFree + memoryUsed 将会少于物理内存总量，在模拟器上则几乎相等
 *
 *  @return 可用内存大小，如果获取失败返回 `-1`
 */
+ (int64_t)memoryFree;

/*!
 *  @abstract 已使用内存大小（单位：字节/Byte）
 *
 *  @discussion 根据 (active + inactive + wire) 内存状况统计
 *
 *  @return 已使用内存大小，如果获取失败返回 `-1`
 */
+ (int64_t)memoryUsed;

/*!
 *  @abstract 已被占用但可被分页的内存（单位：字节/Byte）
 *
 *  @return 已被占用内存大小，如果获取失败返回 `-1`
 */
+ (int64_t)memoryActive;

/*!
 *  @abstract 不活跃的内存（单位：字节/Byte）
 *
 *  @discussion 当系统提出内存不足警告时，应用可以抢占这部分内存
 *
 *  @return 不活跃的内存大小，如果获取失败返回 `-1`
 */
+ (int64_t)memoryInactive;

/*!
 *  @abstract 已被占用但不可被分页的内存（单位：字节/Byte）
 *
 *  @return 已被占用内存大小，如果获取失败返回 `-1`
 */
+ (int64_t)memoryWired;


#pragma mark - CPU状况
///-----------------------------------------------------------------------------
/// @name CPU状况
///-----------------------------------------------------------------------------

/*!
 *  @abstract CPU总核数
 *
 *  @return 总核数
 */
+ (NSUInteger)processorCount;

/*!
 *  @abstract CPU当前可用核数
 *
 *  @return 可用核数
 */
+ (NSUInteger)activeProcessorCount;

/*!
 *  @abstract 当前进程名
 *
 *  @return 进程名
 */
+ (NSString *)processName;

/*!
 *  @abstract CPU每个核使用状况
 *
 *  @return 内容为各核使用状况 `Number` 的数组
 */
+ (NSArray *)cpuUsagePerProcessor;

/*!
 *  @abstract CPU 使用状况
 *
 *  @return 根据 `cpuUsagePerProcessor` 累加获得
 */
+ (float)cpuUsage;

@end

NS_ASSUME_NONNULL_END
