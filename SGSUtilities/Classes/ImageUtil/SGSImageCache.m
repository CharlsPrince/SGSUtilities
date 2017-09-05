/*!
 *  @file SGSImageCache.m
 *
 *  @author Created by Lee on 16/10/28.
 *
 *  @copyright 2016年 SouthGIS. All rights reserved.
 */

#import "SGSImageCache.h"
#import <pthread/pthread.h>


@interface NSMutableArray (SGSImageCache)
- (id)dequeue;
@end

@implementation NSMutableArray (SGSImageCache)
- (id)dequeue {
    id obj = nil;
    if (self.count > 0) {
        obj = self.firstObject;
        [self removeObject:obj];
    }
    return obj;
}
@end

@interface UIImage (SGSImageCache)
+ (UIImage *)safeImageWithData:(NSData *)data;
@end

static NSLock *imageLock = nil;

@implementation UIImage (AFNetworkingSafeImageLoading)

+ (UIImage *)safeImageWithData:(NSData *)data {
    UIImage* image = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageLock = [[NSLock alloc] init];
    });
    
    [imageLock lock];
    image = [UIImage imageWithData:data];
    [imageLock unlock];
    if (image.images == nil) {
        image = [[UIImage alloc] initWithCGImage:[image CGImage] scale:[[UIScreen mainScreen] scale] orientation:image.imageOrientation];
    }
    return image;
}

@end


#pragma mark - 图片下载任务

/// 图片下载任务类，下载进度观察者
@interface ImageDownloadTask : NSObject
@property (nonatomic, strong) NSURLSessionDataTask *task;
@property (nonatomic, strong) NSProgress *progress;
@property (nonatomic, copy) void(^progressBlock)(NSProgress *progress);
@property (nonatomic, copy) SGSImageLoadCompletionHandler handler;
- (void)removeProgressObserver;
@end

@implementation ImageDownloadTask

// 在设置task同时监听加载进度
- (void)setTask:(NSURLSessionDataTask *)task {
    [self removeProgressObserver];
    _task = task;
    
    if (_progress == nil) {
        _progress = [[NSProgress alloc] initWithParent:nil userInfo:nil];
    }
    
    _progress.totalUnitCount = task.countOfBytesExpectedToReceive;
    
    __weak typeof(task) weakTask = task;
    [_progress setCancellable:YES];
    [_progress setCancellationHandler:^{
        __typeof__(weakTask) strongTask = weakTask;
        [strongTask cancel];
    }];
    [_progress setPausable:YES];
    [_progress setPausingHandler:^{
        __typeof__(weakTask) strongTask = weakTask;
        [strongTask suspend];
    }];
    
    if ([_progress respondsToSelector:@selector(setResumingHandler:)]) {
        [_progress setResumingHandler:^{
            __typeof__(weakTask) strongTask = weakTask;
            [strongTask resume];
        }];
    }
    
    [task addObserver:self
           forKeyPath:NSStringFromSelector(@selector(countOfBytesReceived))
              options:NSKeyValueObservingOptionNew
              context:NULL];
    [task addObserver:self
           forKeyPath:NSStringFromSelector(@selector(countOfBytesExpectedToReceive))
              options:NSKeyValueObservingOptionNew
              context:NULL];
    [_progress addObserver:self
                forKeyPath:NSStringFromSelector(@selector(fractionCompleted))
                   options:NSKeyValueObservingOptionNew
                   context:NULL];
}

- (void)removeProgressObserver {
    [self.task removeObserver:self forKeyPath:NSStringFromSelector(@selector(countOfBytesReceived)) context:NULL];
    [self.task removeObserver:self forKeyPath:NSStringFromSelector(@selector(countOfBytesExpectedToReceive)) context:NULL];
    [self.progress removeObserver:self forKeyPath:NSStringFromSelector(@selector(fractionCompleted)) context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context
{
    if ([object isKindOfClass:[NSURLSessionDataTask class]]) {
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(countOfBytesReceived))]) {
            _progress.completedUnitCount = [change[NSKeyValueChangeNewKey] longLongValue];
        } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(countOfBytesExpectedToReceive))]) {
            _progress.totalUnitCount = [change[NSKeyValueChangeNewKey] longLongValue];
        }
    }
    else if ([object isEqual:_progress]) {
        if (_progressBlock) {
            _progressBlock(object);
        }
    }
}

- (void)dealloc {
    [self removeProgressObserver];
}

@end


#pragma mark - 图片缓存

@interface SGSImageCache ()
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) NSCache *memoryCache;
@property (nonatomic, strong) NSMutableArray<ImageDownloadTask *> *taskQueue;
@property (nonatomic, strong) NSMutableDictionary<NSString *, ImageDownloadTask *> *taskRecord;
@property (nonatomic, assign) NSUInteger activeDownloadCount;     // 当前下载任务数
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, assign) NSUInteger maximumActiveDownloads;
@end


@implementation SGSImageCache

+ (instancetype)defaultImageCache {
    static SGSImageCache *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SGSImageCache alloc] initWithName:@"com.southgis.webimagecache" maximumDownloads:6];
    });
    return instance;
}

- (instancetype)initWithName:(NSString *)name maximumDownloads:(NSUInteger)maximumDownloads {
    if (name.length == 0) return [SGSImageCache defaultImageCache];
    
    self = [super init];
    if (self) {
        NSUInteger memoryCapacity = 0; // 内存缓存使用NSCache
        NSUInteger diskCapacity   = 1 << 27; // 128M 磁盘缓存
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.URLCache = [[NSURLCache alloc] initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:name];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        
        NSLock *lock = [[NSLock alloc] init];
        lock.name = name;
        
        NSCache *memoryCache = [[NSCache alloc] init];
        memoryCache.name = name;
        memoryCache.totalCostLimit = 1 << 25; // 32M 内存缓存
        
        _session = session;
        _lock = lock;
        _memoryCache = memoryCache;
        _taskQueue = [NSMutableArray array];
        _taskRecord = [NSMutableDictionary dictionary];
        _activeDownloadCount = 0;
        _maximumActiveDownloads = maximumDownloads;
        _name = name.copy;
    }
    return self;
}

- (NSUInteger)maximumDownloads {
    NSUInteger max = 0;
    [_lock lock];
    max = _maximumActiveDownloads;
    [_lock unlock];
    return max;
}

- (void)setMaximumDownloads:(NSUInteger)maximumDownloads {
    [_lock lock];
    _maximumActiveDownloads = maximumDownloads;
    [_lock unlock];
}

// 获取图片缓存
- (UIImage *)cachedImageForURL:(NSURL *)url {
    if ([url isFileURL]) {
        UIImage *image = [self.memoryCache objectForKey:url.path];
        if (image == nil) {
            NSData *data = [NSData dataWithContentsOfURL:url];
            image = [UIImage imageWithData:data ? data : [NSData data]];
            [self.memoryCache setObject:image forKey:url.path cost:data.length];
        }
        return image;
    } else if (url.absoluteString != nil) {
        return [self.memoryCache objectForKey:url.absoluteString];
    } else {
        return nil;
    }
    
#if 0
    // 由于目前直接使用 NSURLRequestReturnCacheDataElseLoad 策略，所以直接返回内存缓存中的图片
    UIImage *image = [self.memoryCache objectForKey:url.absoluteString];
    if (image != nil) {
        return image;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSCachedURLResponse *response = [_session.configuration.URLCache cachedResponseForRequest:request];
    if (response == nil) {
        return nil;
    }
    
    image = [self inflatedImageFromResponse:response.response withData:response.data];
    if (image != nil) {
        [self.memoryCache setObject:image forKey:url.absoluteString cost:response.data.length];
    }

    return image;
#endif
}

// 加载图片
- (void)loadImageForURL:(NSURL *)url
          progressBlock:(void (^)(NSProgress * _Nonnull))progressBlock
      completionHandler:(SGSImageLoadCompletionHandler)handler
{
    if ([url isFileURL]) {
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data ? data : [NSData data]];
        [self.memoryCache setObject:image forKey:url.path cost:data.length];
        [self invokeCompletionHandlerOnMainQueue:handler withOriginalURL:url image:image error:nil];
    } else {
        [self downloadImageForURL:url progressBlock:progressBlock completionHandler:handler];
    }
}

// 下载图片
- (void)downloadImageForURL:(NSURL *)url
              progressBlock:(void (^)(NSProgress * _Nonnull))progressBlock
          completionHandler:(SGSImageLoadCompletionHandler)handler
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    ImageDownloadTask *task = [self taskForURL:url];
    if (task != nil) {
        task.handler = handler;
        task.progressBlock = progressBlock;
    }
    else {
        task = [[ImageDownloadTask alloc] init];
        task.progressBlock = progressBlock;
        
        __weak typeof(self) _self = self;
        task.task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            __strong typeof(_self) self = _self;
            
            ImageDownloadTask *completionTask = [self taskForURL:url];
            NSURL *originalURL = completionTask.task.originalRequest.URL;
            [self removeTaskForURL:url];
            
            UIImage *image = nil;
            
            if (error == nil) {
                if ([(NSHTTPURLResponse *)response statusCode] >= 400) {
                    error = [NSError errorWithDomain:NSURLErrorDomain code:[(NSHTTPURLResponse *)response statusCode] userInfo:nil];
                }
                else if ((data.length == 0) && ![[self acceptableContentTypes] containsObject:response.MIMEType]) {
                    error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCannotDecodeContentData userInfo:nil];
                }
                else if (data.length == 0) {
                    image = [self cachedImageForURL:originalURL];
                } else {
                    image = [self inflatedImageFromResponse:response withData:data];
                    if (image != nil) {
                        [self.memoryCache setObject:image forKey:originalURL.absoluteString cost:data.length];
                    } else {
                        [self.memoryCache removeObjectForKey:originalURL.absoluteString];
                    }
                }
            }
            
            [self invokeCompletionHandlerOnMainQueue:completionTask.handler withOriginalURL:originalURL image:image error:error];
            
            [self safelyDecrementActiveTaskCount];
            [self safelyStartNextTask];
        }];
        
        [self recordTask:task forURL:url completionHandler:handler];
        [self safelyExecuteTaskIfActiveRequestCountBelowMaximumLimit:task];
    }
}

// 图片类型
- (NSSet *)acceptableContentTypes {
    static NSSet *imageMIMEType;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageMIMEType = [[NSSet alloc] initWithObjects:@"image/tiff", @"image/jpeg", @"image/gif", @"image/png", @"image/ico", @"image/x-icon", @"image/bmp", @"image/x-bmp", @"image/x-xbitmap", @"image/x-win-bitmap", @"image/webp", nil];
    });
    return imageMIMEType;
}

// 解压图片
- (UIImage *)inflatedImageFromResponse:(NSURLResponse *)response withData:(NSData *)data {
    if ((data == nil) || ([data length] == 0)) {
        return nil;
    }
    
    CGImageRef imageRef = NULL;
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    if ([response.MIMEType isEqualToString:@"image/png"]) {
        imageRef = CGImageCreateWithPNGDataProvider(dataProvider,  NULL, true, kCGRenderingIntentDefault);
    } else if ([response.MIMEType isEqualToString:@"image/jpeg"]) {
        imageRef = CGImageCreateWithJPEGDataProvider(dataProvider, NULL, true, kCGRenderingIntentDefault);
        
        if (imageRef) {
            CGColorSpaceRef imageColorSpace = CGImageGetColorSpace(imageRef);
            CGColorSpaceModel imageColorSpaceModel = CGColorSpaceGetModel(imageColorSpace);
            
            if (imageColorSpaceModel == kCGColorSpaceModelCMYK) {
                CGImageRelease(imageRef);
                imageRef = NULL;
            }
        }
    }
    
    CGDataProviderRelease(dataProvider);
    
    UIImage *image = [UIImage safeImageWithData:data];
    if (imageRef == NULL) {
        if (image.images || !image) {
            return image;
        }
        
        imageRef = CGImageCreateCopy([image CGImage]);
        if (imageRef == NULL) {
            return nil;
        }
    }
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    
    if (width * height > 1024 * 1024 || bitsPerComponent > 8) {
        CGImageRelease(imageRef);
        
        return image;
    }
    

    size_t bytesPerRow = 0;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorSpaceModel colorSpaceModel = CGColorSpaceGetModel(colorSpace);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    if (colorSpaceModel == kCGColorSpaceModelRGB) {
        uint32_t alpha = (bitmapInfo & kCGBitmapAlphaInfoMask);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wassign-enum"
        if (alpha == kCGImageAlphaNone) {
            bitmapInfo &= ~kCGBitmapAlphaInfoMask;
            bitmapInfo |= kCGImageAlphaNoneSkipFirst;
        } else if (!(alpha == kCGImageAlphaNoneSkipFirst || alpha == kCGImageAlphaNoneSkipLast)) {
            bitmapInfo &= ~kCGBitmapAlphaInfoMask;
            bitmapInfo |= kCGImageAlphaPremultipliedFirst;
        }
#pragma clang diagnostic pop
    }
    
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo);
    
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        CGImageRelease(imageRef);
        return image;
    }
    
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), imageRef);
    CGImageRef inflatedImageRef = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    UIImage *inflatedImage = [[UIImage alloc] initWithCGImage:inflatedImageRef scale:[[UIScreen mainScreen] scale] orientation:image.imageOrientation];
    
    CGImageRelease(inflatedImageRef);
    CGImageRelease(imageRef);
    
    return inflatedImage;
}

- (void)removeCachedImageForURL:(NSURL *)url {
    [self.memoryCache removeObjectForKey:url.absoluteString];
    [_session.configuration.URLCache removeCachedResponseForRequest:[NSURLRequest requestWithURL:url]];
}

- (void)removeAllCachedImage {
    [self.memoryCache removeAllObjects];
    [_session.configuration.URLCache removeAllCachedResponses];
}

- (void)removeCachedImageSinceDate:(NSDate *)date {
    [self.memoryCache removeAllObjects];
    [_session.configuration.URLCache removeCachedResponsesSinceDate:date];
}

#pragma mark - Task Queue

- (void)safelyExecuteTaskIfActiveRequestCountBelowMaximumLimit:(ImageDownloadTask *)task {
    [_lock lock];
    if (self.activeDownloadCount < self.maximumActiveDownloads) {
        [task.task resume];
        ++self.activeDownloadCount;
    } else {
        [self.taskQueue addObject:task];
    }
    [_lock unlock];
}

- (void)safelyStartNextTask {
    [_lock lock];
    if (self.activeDownloadCount < self.maximumActiveDownloads) {
        while (self.taskQueue.count > 0) {
            ImageDownloadTask *task = [self.taskQueue dequeue];
            if (task.task.state == NSURLSessionTaskStateSuspended) {
                [task.task resume];
                ++self.activeDownloadCount;
                break;
            }
        }
    }
    [_lock unlock];
}

- (void)safelyDecrementActiveTaskCount {
    [_lock lock];
    if (self.activeDownloadCount > 0) {
        --self.activeDownloadCount;
    }
    [_lock unlock];
}

#pragma mark - Task Record

- (void)removeTaskForURL:(NSURL *)url {
    [self recordTask:nil forURL:url completionHandler:nil];
}

- (void)recordTask:(ImageDownloadTask *)task forURL:(NSURL *)url completionHandler:(SGSImageLoadCompletionHandler)handler {
    if (task != nil) {
        task.handler = handler;
    }
    
    [_lock lock];
    _taskRecord[url.absoluteString] = task;
    [_lock unlock];
}

- (void)cancelTaskIgnoreURL:(NSURL *)url {
    [_lock lock];
    __block ImageDownloadTask *task = nil;
    [_taskRecord enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, ImageDownloadTask * _Nonnull obj, BOOL * _Nonnull stop) {
        if ((url != nil) && [key isEqualToString:url.absoluteString]) {
            task = obj;
        } else {
            [task.task cancel];
        }
    }];
    _taskRecord = [NSMutableDictionary dictionaryWithObjectsAndKeys:task, url.absoluteString, nil];
    [_lock unlock];
}

- (ImageDownloadTask *)taskForURL:(NSURL *)url {
    ImageDownloadTask *task = nil;
    [_lock lock];
    task = _taskRecord[url.absoluteString];
    [_lock unlock];
    
    return task;
}

#pragma mark - Invoke Block

- (void)invokeCompletionHandlerOnMainQueue:(SGSImageLoadCompletionHandler)handler withOriginalURL:(NSURL *)url image:(UIImage *)image error:(NSError *)error {
    if (handler != nil) {
        if (pthread_main_np()) {
            handler(url, image, error);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(url, image, error);
            });
        }
    }
}

@end
