/*!
 *  @file SGSBannerView.h
 *
 *  @abstract 横幅轮播视图
 *
 *  @author Created by Lee on 16/5/13.
 *
 *  @copyright 2016年 SouthGIS. All rights reserved.
 */

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@class SGSBannerView;

/*! 横幅视图数据源协议 */
@protocol SGSBannerModelProtocol <NSObject>

@required
/*! 图片的URL */
- (NSURL *)imageURL;

@optional
/*! 标题字符串 */
- (NSString *)titleString;

@end


/*! 横幅视图代理协议 */
@protocol SGSBannerViewDelegate <NSObject>
@optional
/*!
 *  @abstract 当tap横幅时触发的代理方法
 *
 *  @param banner 横幅视图
 *  @param index  当前内容下标
 */
- (void)tapedBannerView:(SGSBannerView *)banner withIndex:(NSUInteger)index;
@end

/*! 让 NSURL 实现 SGSBannerModelProtocol */
@interface NSURL (SGSBanner) <SGSBannerModelProtocol>
@end


/*! 轮播横幅视图样式 */
typedef NS_OPTIONS(NSUInteger, SGSBannerViewStyle) {
    SGSBannerViewStyleNone        = 0,      //! 无样式
    SGSBannerViewStylePageControl = 1 << 0, //! 底部显示小圆点控制条
    SGSBannerViewStyleTitle       = 1 << 1, //! 底部显示标题
    
    SGSBannerViewStylePageControlAndTitle = SGSBannerViewStylePageControl | SGSBannerViewStyleTitle,
};



#pragma mark - 横幅轮播视图

/*! 横幅轮播视图 */
@interface SGSBannerView : UIView

/*! 轮播时间间隔，小于等于0不自动轮播 */
@property (nonatomic, assign) NSTimeInterval timeInterval;

/*! 数据源数组 */
@property (nonatomic, copy) NSArray<id<SGSBannerModelProtocol>> *dataSourceArray;

/*! 默认图片 */
@property (nullable, nonatomic, strong) UIImage *placeholderImage;

/*! 点击事件代理 */
@property (nullable, nonatomic, weak) id<SGSBannerViewDelegate> delegate;

/*! 横幅视图内图片的样式，默认为 UIViewContentModeScaleToFill */
@property (nonatomic, assign) UIViewContentMode bannerContentMode;

/*! 底部的掩膜视图，如果样式为 SGSBannerViewStyleNone，那么该视图为空  */
@property (nullable, nonatomic, strong, readonly) UIView *bottomMaskView;

/*! 底部的页面控制器，如果样式为 SGSBannerViewStyleNone或者SGSBannerViewStyleTitle，那么该视图为空  */
@property (nullable, nonatomic, strong, readonly) UIPageControl *pageControl;

/*! 底部的标题，如果样式为 SGSBannerViewStyleNone或者SGSBannerViewStylePageControl，那么该视图为空  */
@property (nullable, nonatomic, strong, readonly) UILabel *titleLabel;


/*!
 *  @abstract 便捷初始化方法
 *
 *  @discussion frame 默认为 CGRectZero，timeInterval 默认为 4秒
 *
 *  @param style            横幅样式
 *  @param placeholderImage 默认图片
 *
 *  @return 横幅视图
 */
- (instancetype)initWithStyle:(SGSBannerViewStyle)style placeholderImage:(nullable UIImage *)placeholderImage;

/*!
 *  @abstract 指定初始化方法
 *
 *  @discussion  初始化方式：
 *      - 1.如果使用 -init 方法创建该视图，那么 frame = CGRectZero，timeInterval = 4秒，样式为 None
 *      - 2.如果使用 -initWithFrame: 创建该视图，那么 frame = frame，timeInterval = 4秒，样式为 None
 *      - 3.如果使用 xib 或 Storyboard 创建该视图，那么 frame 将根据在xib或Storyboard中来确定
 *          timeInterval = 4秒，样式为 None
 *
 *  @param frame            初始范围
 *  @param timeInterval     轮播间隔
 *  @param style            横幅样式
 *  @param placeholderImage 默认图片
 *
 *  @return 横幅视图
 */
- (instancetype)initWithFrame:(CGRect)frame cutTimeInterval:(NSTimeInterval)timeInterval style:(SGSBannerViewStyle)style placeholderImage:(nullable UIImage *)placeholderImage NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
