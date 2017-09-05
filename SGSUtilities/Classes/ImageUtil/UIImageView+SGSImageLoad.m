/*!
 *  @file UIImageView+SGSImageLoad.m
 *
 *  @abstract 图片缓存
 *
 *  @author Created by Lee on 16/10/28.
 *
 *  @copyright 2016年 SouthGIS. All rights reserved.
 */

#import "UIImageView+SGSImageLoad.h"
#import <objc/runtime.h>

static int kImageURLKey;

@implementation UIImageView (SGSImageLoad)

- (NSURL *)imageURL {
    return objc_getAssociatedObject(self, &kImageURLKey);
}

- (void)setImageWithURL:(NSURL *)url {
    [self setImageWithURL:url placeholder:nil progressBlock:nil completion:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholder:(UIImage *)placeholder {
    [self setImageWithURL:url placeholder:placeholder progressBlock:nil completion:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholder:(UIImage *)placeholder completion:(void (^)(NSURL * _Nonnull, UIImage * _Nullable, NSError * _Nullable))completion {
    [self setImageWithURL:url placeholder:placeholder progressBlock:nil completion:completion];
}

- (void)setImageWithURL:(NSURL *)url
            placeholder:(UIImage *)placeholder
          progressBlock:(void (^)(NSProgress * _Nonnull))progressBlock
             completion:(void (^)(NSURL * _Nonnull, UIImage * _Nullable, NSError * _Nullable))completion
{
    [self setImageWithURL:url placeholder:placeholder fromImageCache:nil progressBlock:progressBlock completion:completion];
}

- (void)setImageWithURL:(NSURL *)url
            placeholder:(UIImage *)placeholder
         fromImageCache:(SGSImageCache *)imageCache
          progressBlock:(void (^)(NSProgress * _Nonnull))progressBlock
             completion:(void (^)(NSURL * _Nonnull, UIImage * _Nullable, NSError * _Nullable))completion
{
    objc_setAssociatedObject(self, &kImageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (url == nil) {
        self.image = placeholder;
        [self invokeCompletionHandler:completion withURL:url image:nil error:nil];
        return;
    }
    
    if (imageCache == nil) imageCache = [SGSImageCache defaultImageCache];
    
    UIImage *cachedImage = [imageCache cachedImageForURL:url];
    if (cachedImage != nil) {
        self.image = cachedImage;
        [self invokeCompletionHandler:completion withURL:url image:cachedImage error:nil];
        return;
    }
    
    self.image = placeholder;
    
    __weak typeof(self) _self = self;
    [imageCache loadImageForURL:url progressBlock:progressBlock completionHandler:^(NSURL * _Nonnull originalURL, UIImage * _Nullable image, NSError * _Nullable error) {
        __strong typeof(_self) self = _self;
        if ([self isActiveTaskURLEqualToURL:originalURL]) {
            if (image != nil) {
                self.image = image;
            }
            [self invokeCompletionHandler:completion withURL:originalURL image:image error:error];
        }
    }];
}

- (BOOL)isActiveTaskURLEqualToURL:(NSURL *)url {
    return [[self imageURL].absoluteString isEqualToString:url.absoluteString];
}

- (void)invokeCompletionHandler:(void (^)(NSURL * _Nonnull, UIImage * _Nullable, NSError * _Nullable))handler withURL:(NSURL *)url image:(UIImage *)image error:(NSError *)error {
    if (handler != nil) {
        handler(url, image, error);
    }
}

@end
