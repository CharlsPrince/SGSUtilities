/*!
 *  @file SGSBannerView.m
 *
 *  @author Created by Lee on 16/5/13.
 *
 *  @copyright 2016年 SouthGIS. All rights reserved.
 */

#import "SGSBannerView.h"
#import <SGSUtilities/UIImageView+SGSImageLoad.h>

typedef void(^TimerHandler)();

#pragma mark - NSTimer

@interface NSTimer (SGSBannerTimer)
+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(TimerHandler)block repeats:(BOOL)repeats;
@end

@implementation NSTimer (SGSBannerTimer)
+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(TimerHandler)block repeats:(BOOL)repeats {
    return [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(p_blockInvoke:) userInfo:[block copy] repeats:repeats];
}
+ (void)p_blockInvoke:(nullable NSTimer *)timer {
    TimerHandler block = timer.userInfo;
    if (block) {
        block();
    }
}
@end

#pragma mark - NSURL

@implementation NSURL (SGSBanner)
- (NSURL *)imageURL {
    return self;
}
@end

#pragma mark - SGSBannerView

@interface SGSBannerView () <UIScrollViewDelegate>
@property (nonatomic, assign) SGSBannerViewStyle style;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIView *box;
@property (nonatomic, strong) NSLayoutConstraint *boxWidthConstraint;

@property (nonatomic, strong) NSLayoutConstraint *pageControlWidthConstraint;

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, assign) NSUInteger currentIdx;
@property (nonatomic, strong) NSDictionary *titleTextAttribute;
@end


@implementation SGSBannerView

#pragma mark - Getter and Setter

// 当重置轮播间隔时间的时候，更新定时器
- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    _timeInterval = timeInterval;
    
    // 如果轮播间隔很小则停止定时器
    if (_timeInterval <= 0) {
        [self stopTimer];
    } else {
        [self startTimer];
    }
}

- (void)setDataSourceArray:(NSArray<id<SGSBannerModelProtocol>> *)dataSourceArray
{
    _dataSourceArray = dataSourceArray.copy;
    _count = _dataSourceArray.count;
    
    if (_pageControl != nil) {
        _pageControl.numberOfPages = _count;
        
        if (_pageControlWidthConstraint != nil) {
            _pageControlWidthConstraint.constant = [_pageControl sizeForNumberOfPages:_count + 1].width;
        }
    }
    
    if (_count > 0) {
        [self loadData];
        
        // 图片大于1张才能滚动
        _contentScrollView.scrollEnabled = (_count > 1);
        
        _boxWidthConstraint.constant = (_contentScrollView.bounds.size.width * 3);
        
        // 初始偏移量
        [_contentScrollView setContentOffset:CGPointMake(_contentScrollView.bounds.size.width, 0)];
        
        [self startTimer];
    } else {
        [self stopTimer];
    }
}


#pragma mark - 初始化及设置

// 便捷初始化方法
- (instancetype)init {
    return [self initWithFrame:CGRectZero
               cutTimeInterval:4.0
                         style:SGSBannerViewStyleNone
              placeholderImage:nil];
}

// 便捷初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame
               cutTimeInterval:4.0
                         style:SGSBannerViewStyleNone
              placeholderImage:nil];
}

// 便捷初始化方法
- (instancetype)initWithStyle:(SGSBannerViewStyle)style placeholderImage:(UIImage *)placeholderImage {
    return [self initWithFrame:CGRectZero cutTimeInterval:4.0 style:style placeholderImage:placeholderImage];
}

// 指定初始化方法
- (instancetype)initWithFrame:(CGRect)frame
              cutTimeInterval:(NSTimeInterval)timeInterval
                        style:(SGSBannerViewStyle)style
             placeholderImage:(UIImage *)placeholderImage
{
    self = [super initWithFrame:frame];
    if (self) {
        _timeInterval = timeInterval;
        _count = 0;
        _style = style;
        _placeholderImage = placeholderImage;
        _bannerContentMode = UIViewContentModeScaleToFill;
        _dataSourceArray = @[];
        
        if (_style < SGSBannerViewStyleNone || _style > SGSBannerViewStylePageControlAndTitle) {
            _style = SGSBannerViewStyleNone;
        }
        
        NSMutableParagraphStyle *titleParagraphStyle = [NSMutableParagraphStyle new];
        titleParagraphStyle.firstLineHeadIndent = 10.0; // 首行缩进10pt
        
        _titleTextAttribute = @{NSParagraphStyleAttributeName: titleParagraphStyle, NSForegroundColorAttributeName: [UIColor whiteColor]};
        
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self init];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _timeInterval = 4.0;
    _count = 0;
    _style = SGSBannerViewStyleNone;
    _placeholderImage = nil;
    _bannerContentMode = UIViewContentModeScaleToFill;
    _dataSourceArray = @[];
    
    NSMutableParagraphStyle *titleParagraphStyle = [NSMutableParagraphStyle new];
    titleParagraphStyle.firstLineHeadIndent = 10.0; // 首行缩进10pt
    
    _titleTextAttribute = @{NSParagraphStyleAttributeName: titleParagraphStyle, NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    [self setup];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_contentScrollView != nil && _boxWidthConstraint != nil) {
        // 当banner改变大小的时候，一并改变图片的宽度
        _boxWidthConstraint.constant = (_contentScrollView.bounds.size.width * 3);
        [_contentScrollView setContentOffset:CGPointMake(_contentScrollView.bounds.size.width, 0)];
    }
}

- (void)setup {
    // 设置ScrollView
    [self setupScrollView];
    
    // 设置PageControl和TitleLabel
    [self setupPageControlAndTitleLabel];
    
    // 设置ImageView
    [self setupImageView];
}

// 设置ScrollView
- (void)setupScrollView
{
    _contentScrollView = [[UIScrollView alloc] init];
    _contentScrollView.showsVerticalScrollIndicator = NO; // 隐藏垂直滚动条
    _contentScrollView.showsHorizontalScrollIndicator = NO; // 隐藏水平滚动条
    _contentScrollView.pagingEnabled = YES; // 可翻页效果
    _contentScrollView.bounces = NO; // 到边界不能拖动
    _contentScrollView.alwaysBounceHorizontal = YES; // 只能水平滑动
    _contentScrollView.directionalLockEnabled = YES; // 锁定水平滑动
    _contentScrollView.delegate = self;
    _contentScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_contentScrollView];
    
    // ScrollView适配
    NSDictionary *scrollViewBinding = NSDictionaryOfVariableBindings(_contentScrollView);
    NSArray *scrollViewConstraintH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_contentScrollView]-0-|" options:kNilOptions metrics:nil views:scrollViewBinding];
    [self addConstraints:scrollViewConstraintH];
    
    NSArray *scrollViewConstraintV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_contentScrollView]-0-|" options:kNilOptions metrics:nil views:scrollViewBinding];
    [self addConstraints:scrollViewConstraintV];
    
    [self layoutIfNeeded];
}

// 设置PageControl和TitleLabel
- (void)setupPageControlAndTitleLabel
{
    if (_style == SGSBannerViewStyleNone) return;
    
    UIView *subBackgroundView = [[UIView alloc] init];
    subBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    subBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:subBackgroundView];
    
    NSDictionary *subBackgroundViewBinding = NSDictionaryOfVariableBindings(subBackgroundView);
    NSArray *subBackgroundViewConstraintH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[subBackgroundView]-0-|" options:kNilOptions metrics:nil views:subBackgroundViewBinding];
    [self addConstraints:subBackgroundViewConstraintH];
    
    NSArray *subBackgroundViewConstraintV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[subBackgroundView(30)]-0-|" options:kNilOptions metrics:nil views:subBackgroundViewBinding];
    [self addConstraints:subBackgroundViewConstraintV];
    
    
    NSArray *subviewHorizontalConstraints = nil;
    
    if (_style & SGSBannerViewStylePageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.enabled = NO;
        _pageControl.translatesAutoresizingMaskIntoConstraints = NO;
        [subBackgroundView addSubview:_pageControl];
        
        NSDictionary *pageControlBinding = NSDictionaryOfVariableBindings(_pageControl, subBackgroundView);
        /** 纵向约束 */
        NSArray *pageControlVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_pageControl(==subBackgroundView)]-0-|" options:kNilOptions metrics:nil views:pageControlBinding];
        [subBackgroundView addConstraints:pageControlVerticalConstraints];
        
        /** 横向约束 */
        subviewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_pageControl]-0-|" options:kNilOptions metrics:nil views:pageControlBinding];
    }
    
    if (_style & SGSBannerViewStyleTitle) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [subBackgroundView addSubview:_titleLabel];
        
        NSDictionary *titleLabelBinding = NSDictionaryOfVariableBindings(_titleLabel, subBackgroundView);
        /** 纵向约束 */
        NSArray *titleLabelVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleLabel(==subBackgroundView)]-0-|" options:kNilOptions metrics:nil views:titleLabelBinding];
        [subBackgroundView addConstraints:titleLabelVerticalConstraints];
        
        /** 横向约束 */
        subviewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_titleLabel]-0-|" options:kNilOptions metrics:nil views:titleLabelBinding];
    }
    
    if ((_style & SGSBannerViewStylePageControl) && (_style & SGSBannerViewStyleTitle)) {
        NSLog(@"pageControl与title的横向约束");
        NSDictionary *bindingViews = NSDictionaryOfVariableBindings(_titleLabel, _pageControl);
        NSMutableArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_titleLabel]-0-[_pageControl]-0-|" options:kNilOptions metrics:nil views:bindingViews].mutableCopy;
        
        CGSize size = [_pageControl sizeForNumberOfPages:_count + 1];
        _pageControlWidthConstraint = [NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size.width];
        [horizontalConstraints addObject:_pageControlWidthConstraint];
        
        subviewHorizontalConstraints = horizontalConstraints.copy;
    }
    
    if (subviewHorizontalConstraints != nil) {
        [subBackgroundView addConstraints:subviewHorizontalConstraints];
    }
    
    _bottomMaskView = subBackgroundView;
    
    [self layoutIfNeeded];
}

// 设置ImageView
- (void)setupImageView
{
    // 初始化ImageView的父视图box
    UIView *box = [[UIView alloc] init];
    box.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentScrollView addSubview:box];
    
    // box适配
    NSDictionary *boxBinding = NSDictionaryOfVariableBindings(box, _contentScrollView);
    NSArray *boxConstraintH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[box]-0-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:boxBinding];
    [_contentScrollView addConstraints:boxConstraintH];
    
    
    NSArray *boxConstraintV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[box(==_contentScrollView)]-0-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:boxBinding];
    [_contentScrollView addConstraints:boxConstraintV];
    _boxWidthConstraint = [NSLayoutConstraint constraintWithItem:box attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
    [_contentScrollView addConstraint:_boxWidthConstraint];
    
    // 左视图
    _leftImageView = [[UIImageView alloc] init];
    _leftImageView.contentMode = _bannerContentMode;
    _leftImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [box addSubview:_leftImageView];
    
    // 中间视图
    _centerImageView = [[UIImageView alloc] init];
    _centerImageView.contentMode = _bannerContentMode;
    _centerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    // 开启交互
    _centerImageView.userInteractionEnabled = YES;
    // 添加点击手势
    [_centerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapedCenterImageView:)]];
    [box addSubview:_centerImageView];
    
    // 右视图
    _rightImageView = [[UIImageView alloc] init];
    _rightImageView.contentMode = _bannerContentMode;
    _rightImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [box addSubview:_rightImageView];
    
    // ImageView适配
    NSDictionary *imageViewBinding = NSDictionaryOfVariableBindings(_leftImageView, _centerImageView, _rightImageView, _contentScrollView);
    NSArray *imageViewConstraintH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_leftImageView]-0-[_centerImageView(==_leftImageView)]-0-[_rightImageView(==_leftImageView)]-0-|" options:(NSLayoutFormatAlignAllBottom | NSLayoutFormatAlignAllTop) metrics:nil views:imageViewBinding];
    [box addConstraints:imageViewConstraintH];
    
    NSArray *imageViewConstraintV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_leftImageView]-0-|" options:kNilOptions metrics:nil views:imageViewBinding];
    [box addConstraints:imageViewConstraintV];
    
    [box layoutIfNeeded];
}

// 响应点击图片的方法
- (void)tapedCenterImageView:(UITapGestureRecognizer *)tap {
    if ((_count > 0) && [self.delegate respondsToSelector:@selector(tapedBannerView:withIndex:)]) {
        [self.delegate tapedBannerView:self withIndex:_currentIdx];
    }
}

#pragma mark - 加载数据


// 启动定时器轮播
- (void)startTimer {
    [self stopTimer];
    
    if (_count > 1) {
        // 使用该方法创建的 timer 不会持有 bannerView
        __weak typeof(self) weakSelf = self;
        _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval block:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf autoOffset];
        } repeats:YES];
    }
}

- (void)autoOffset {
    [_contentScrollView setContentOffset:CGPointMake(_contentScrollView.bounds.size.width * 2, 0) animated:YES];
}

// 取消定时器轮播
- (void)stopTimer {
    if (_timer != nil && _timer.valid) {
        [_timer invalidate];
        _timer = nil;
    }
}

// 加载图片
- (void)loadData {
    // 左视图
    [self renderImageView:_leftImageView withImageURL:[_dataSourceArray.lastObject imageURL]];
    
    // 中间视图
    [self renderImageView:_centerImageView withImageURL:[_dataSourceArray.firstObject imageURL]];
    
    // 右视图
    // 判断是否大于两张
    if (_count > 2) {
        [self renderImageView:_rightImageView withImageURL:[_dataSourceArray[1] imageURL]];
    } else {
        [self renderImageView:_rightImageView withImageURL:[_dataSourceArray.lastObject imageURL]];
    }
    
    if ([_dataSourceArray.firstObject respondsToSelector:@selector(titleString)]) {
        [self loadTitle:[_dataSourceArray.firstObject titleString]];
    }
}

- (void)renderImageView:(UIImageView *)imageView withImageURL:(NSURL *)imageURL {
    [imageView setImageWithURL:imageURL placeholder:_placeholderImage];
}

// 加载标题
- (void)loadTitle:(NSString*)title {
    if (_titleLabel != nil) {
        _titleLabel.attributedText = [[NSAttributedString alloc] initWithString:title attributes:_titleTextAttribute];
    }
}

- (void)changePage:(NSUInteger)index {
    if (_pageControl != nil) {
        _pageControl.currentPage = index;
    }
}

// 滚动之后重新加载图片
- (void)reloadImage {
    if (_count == 0) return;
    
    CGPoint offsetPoint = _contentScrollView.contentOffset;
    
    // 左滑
    if (offsetPoint.x < self.bounds.size.width) {
        _currentIdx = (_currentIdx - 1 + _count) % _count;
    }
    // 右滑
    else if (offsetPoint.x > self.bounds.size.width) {
        _currentIdx = (_currentIdx + 1) % _count;
    }
    
    [self renderImageView:_centerImageView withImageURL:[_dataSourceArray[_currentIdx] imageURL]];
    
    // 重置图片
    NSUInteger leftIdx = (_currentIdx - 1 + _count) % _count;
    NSUInteger rightIdx = (_currentIdx + 1) % _count;
    [self renderImageView:_leftImageView withImageURL:[_dataSourceArray[leftIdx] imageURL]];
    [self renderImageView:_rightImageView withImageURL:[_dataSourceArray[rightIdx] imageURL]];
}

#pragma mark - getter & setter 

- (void)setBannerContentMode:(UIViewContentMode)bannerContentMode {
    _bannerContentMode = bannerContentMode;
    
    _leftImageView.contentMode   = bannerContentMode;
    _centerImageView.contentMode = bannerContentMode;
    _rightImageView.contentMode  = bannerContentMode;
}

#pragma mark - UIScrollViewDelegate
// 手动滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self reloadImage];
    [scrollView setContentOffset:CGPointMake(scrollView.bounds.size.width, 0)];
    
    if ([_dataSourceArray[_currentIdx] respondsToSelector:@selector(titleString)]) {
        [self loadTitle:[_dataSourceArray[_currentIdx] titleString]];
    }
    [self changePage:_currentIdx];
}

// 动画滑动
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self reloadImage];
    [scrollView setContentOffset:CGPointMake(scrollView.bounds.size.width, 0)];
    
    if ([_dataSourceArray[_currentIdx] respondsToSelector:@selector(titleString)]) {
        [self loadTitle:[_dataSourceArray[_currentIdx] titleString]];
    }
    [self changePage:_currentIdx];
}

@end
