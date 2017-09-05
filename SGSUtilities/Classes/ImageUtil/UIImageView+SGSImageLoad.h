/*!
 *  @file UIImageView+SGSImageLoad.h
 *
 *  @abstract 图片加载扩展
 *
 *  @author Created by Lee on 16/10/28.
 *
 *  @copyright 2016年 SouthGIS. All rights reserved.
 */

@import UIKit;
#import "SGSImageCache.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 *  @abstract 图片加载扩展
 */
@interface UIImageView (SGSImageLoad)

/*!
 *  @abstract 网络图片地址或本地图片地址
 *
 *  @see NSURL or nil
 */
- (nullable NSURL *)imageURL;

/*!
 *  @abstract 加载本地图片或网络图片
 *
 *  @param url           本地图片或网络图片的URL
 *
 *  @see `-setImageWithURL:placeholder:progressBlock:completion:`
 */
- (void)setImageWithURL:(NSURL *)url;

/*!
 *  @abstract 加载本地图片或网络图片
 *
 *  @param url           本地图片或网络图片的URL
 *  @param placeholder   加载前的默认图片
 *
 *  @see `-setImageWithURL:placeholder:progressBlock:completion:`
 */
- (void)setImageWithURL:(NSURL *)url
            placeholder:(nullable UIImage *)placeholder;

/*!
 *  @abstract 加载本地图片或网络图片
 *
 *  @param url           本地图片或网络图片的URL
 *  @param placeholder   加载前的默认图片
 *  @param completion    加载完毕回调闭包，在主线程中回调，如果 error 为空表示加载成功
 *
 *  @see `-setImageWithURL:placeholder:progressBlock:completion:`
 */
- (void)setImageWithURL:(NSURL *)url
            placeholder:(nullable UIImage *)placeholder
             completion:(nullable void(^)(NSURL *url, UIImage *_Nullable image, NSError * _Nullable error))completion;

/*!
 *  @abstract 加载本地图片或网络图片
 *
 *  @param url           本地图片或网络图片的URL
 *  @param placeholder   加载前的默认图片
 *  @param progressBlock 加载进度回调闭包，在子线程中回调
 *  @param completion    加载完毕回调闭包，在主线程中回调，如果 error 为空表示加载成功
 *
 *  @discussion 使用 [SGSImageCache defaultImageCache] 管理图片缓存
 *
 *  @see `-setImageWithURL:placeholder:fromImageCache:progressBlock:completion:`
 */
- (void)setImageWithURL:(NSURL *)url
            placeholder:(nullable UIImage *)placeholder
          progressBlock:(nullable void(^)(NSProgress *progress))progressBlock
             completion:(nullable void(^)(NSURL *url, UIImage *_Nullable image, NSError * _Nullable error))completion;

/*!
 *  @abstract 加载本地图片或网络图片
 *
 *  @param url           本地图片或网络图片的URL
 *  @param placeholder   加载前的默认图片
 *  @param imageCache    图片缓存，如果为空默认使用 [SGSImageCache defaultImageCache]
 *  @param progressBlock 加载进度回调闭包，在子线程中回调
 *  @param completion    加载完毕回调闭包，在主线程中回调，如果 error 为空表示加载成功
 *
 *  @attention 目前不支持 webp 格式图片，加载 gif 图没有动图效果，如果需要加载 gif 图请使用 `animationImages` 属性设置
 *
 *  @todo 考虑之后支持 webp 和 gif 动图的加载
 */
- (void)setImageWithURL:(NSURL *)url
            placeholder:(nullable UIImage *)placeholder
         fromImageCache:(nullable SGSImageCache *)imageCache
          progressBlock:(nullable void(^)(NSProgress *progress))progressBlock
             completion:(nullable void(^)(NSURL *url, UIImage *_Nullable image, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
