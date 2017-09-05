/*!
 *  @file SGSAppUtil.h
 *
 *  @abstract App 服务相关便捷方法
 *
 *  @author Created by Lee on 16/9/2.
 *
 *  @copyright 2016年 SouthGIS. All rights reserved.
 */

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/*!
 *  @class SGSAppUtil
 *  @abstract App 工具类
 */
@interface SGSAppUtil : NSObject


#pragma mark - 沙盒路径
///-----------------------------------------------------------------------------
/// @name 沙盒路径
///-----------------------------------------------------------------------------

/*!
 *  @abstract 沙盒中的 'Documents' 目录
 *
 *  @return ~/Documents URL
 */
+ (NSURL *)documentsURL;


/*!
 *  @abstract 沙盒中的 'Documents' 目录
 *
 *  @return ~/Documents Path
 */
+ (NSString *)documentsPath;


/*!
 *  @abstract 沙盒中的 'Caches' 目录
 *
 *  @return ~/Library/Caches URL
 */
+ (NSURL *)cachesURL;


/*!
 *  @abstract 沙盒中的 'Caches' 目录
 *
 *  @return ~/Library/Caches Path
 */
+ (NSString *)cachesPath;


/*!
 *  @abstract 沙盒中的 'Library' 目录
 *
 *  @return ~/Library URL
 */
+ (NSURL *)libraryURL;


/*!
 *  @abstract 沙盒中的 'Library' 目录
 *
 *  @return ~/Library Path
 */
+ (NSString *)libraryPath;


#pragma mark - App 信息
///-----------------------------------------------------------------------------
/// @name App 信息
///-----------------------------------------------------------------------------

/*!
 *  @abstract App info.plist 中的键值对信息
 *
 *  @return info Dictionary
 */
+ (nullable NSDictionary *)mainBundleInfo;


/*!
 *  @abstract App名称
 *
 *  @return CFBundleName
 */
+ (nullable NSString *)appName;


/*!
 *  @abstract App BundleID
 *
 *  @return CFBundleIdentifier
 */
+ (nullable NSString *)appBundleID;


/*!
 *  @abstract App版本
 *
 *  @return CFBundleShortVersionString
 */
+ (nullable NSString *)appVersion;


/*!
 *  @abstract App构建版本
 *
 *  @return CFBundleVersion
 */
+ (nullable NSString *)appBuildVersion;


/*!
 *  @abstract 获取应用图标角标数值
 *
 *  @return 角标数值
 */
+ (NSInteger)appIconBadgeNumber;


/*!
 *  @abstract 设置应用图标角标数值
 *
 *  @discussion iOS 8.0 以后在设置之前一定要先注册通知:
 *      -[UIApplication registerUserNotificationSettings:]
 *
 *  @param number 角标数值
 */
+ (void)setAppIconBadgeNumber:(NSInteger)number;


/*!
 *  @abstract 清空应用图标角标数值
 */
+ (void)clearAppIconBadgeNumber;

@end

NS_ASSUME_NONNULL_END
