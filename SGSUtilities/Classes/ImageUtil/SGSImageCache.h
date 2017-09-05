/*!
 *  @file SGSImageCache.h
 *
 *  @abstract 图片缓存
 *
 *  @author Created by Lee on 16/10/28.
 *
 *  @copyright 2016年 SouthGIS. All rights reserved.
 */

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

/*!
 *  @abstract 图片加载回调闭包
 *
 *  @param image 图片
 *  @param error 图片加载错误，如果为空表示加载成功
 */
typedef void(^SGSImageLoadCompletionHandler)(NSURL *originalURL, UIImage * _Nullable image, NSError * _Nullable error);


/*!
 *  @abstract 图片缓存
 */
@interface SGSImageCache : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, assign) NSUInteger maximumDownloads; // 最大允许下载任务数

/*!
 *  @abstract 单例，最大允许下载任务数为6个
 *
 *  @return SGSImageCache 实例
 */
+ (instancetype)defaultImageCache;

- (instancetype)initWithName:(NSString *)name maximumDownloads:(NSUInteger)maximumDownloads;

/*!
 *  @abstract 获取本地图片或网络缓存图片
 *
 *  @param url 图片URL或fileURL
 *
 *  @return UIImage or nil
 */
- (nullable UIImage *)cachedImageForURL:(NSURL *)url;

/*!
 *  @abstract 加载本地图片或网络图片
 *
 *  @param url           图片URL或fileURL
 *  @param progressBlock 加载进度回调闭包，在子线程中回调
 *  @param handler       加载完成回调闭包，在主线程中回调
 */
- (void)loadImageForURL:(NSURL *)url
          progressBlock:(nullable void(^)(NSProgress *progress))progressBlock
      completionHandler:(nullable SGSImageLoadCompletionHandler)handler;


/*!
 *  @abstract 根据URL删除图片缓存
 *
 *  @param url 图片URL，如果是 fileURL 类型则不删除
 *
 *  @warning 由于内部磁盘存储使用了 `NSURLCache` 进行缓存管理，在调用该方法时会通过 `NSURLCache` 的
 *      `-removeCachedResponseForRequest:` 方法删除磁盘上的缓存，但该方法并没有删除效果。
 *      截止至目前的 iOS10.1 仍未解决这个问题。内存缓存使用了 `NSCache` 因此可以正常删除
 */
- (void)removeCachedImageForURL:(NSURL *)url;

/*!
 *  @abstract 删除所有图片缓存
 */
- (void)removeAllCachedImage;

/*!
 *  @abstract 删除指定日期前的图片缓存
 *
 *  @param date 指定日期
 */
- (void)removeCachedImageSinceDate:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
