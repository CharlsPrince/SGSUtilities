//
//  BannerViewController.m
//  SGSUtilities
//
//  Created by Lee on 16/10/31.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "BannerViewController.h"
#import <SGSUtilities/SGSBannerView.h>
#import <SGSUtilities/SGSImageCache.h>

@interface BannerViewController () <SGSBannerViewDelegate>
@property (nonatomic, strong) SGSBannerView *bannerView;
@property (nonatomic, strong) UILabel *label;
@end

@implementation BannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self setupUI];
}

- (void)clearCache:(UIBarButtonItem *)sender {
    [[SGSImageCache defaultImageCache] removeAllCachedImage];
}

- (void)setupUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清除图片缓存" style:UIBarButtonItemStyleDone target:self action:@selector(clearCache:)];
    
    
    NSArray *imagePaths = @[@"https://s-media-cache-ak0.pinimg.com/1200x/2e/0c/c5/2e0cc5d86e7b7cd42af225c29f21c37f.jpg",
                            @"http://i.imgur.com/uoBwCLj.gif",
                            @"http://i.imgur.com/8KHKhxI.gif",
                            @"http://i.imgur.com/WXJaqof.gif",
                            @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1780193/dots18.gif",
                            @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1809343/dots17.1.gif",
                            @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1845612/dots22.gif",
                            @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1820014/big-hero-6.gif",
                            @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1819006/dots11.0.gif",
                            @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1799885/dots21.gif"];
    
    NSMutableArray *imageURLs = [NSMutableArray arrayWithCapacity:imagePaths.count];
    for (NSString *path in imagePaths) {
        NSURL *url = [NSURL URLWithString:path];
        if (url) [imageURLs addObject:url];
    }
    
    UIImage *placeholderImage = [UIImage imageNamed:@"icon_512"];
    _bannerView = [[SGSBannerView alloc] initWithStyle:SGSBannerViewStylePageControl placeholderImage:placeholderImage];
    _bannerView.backgroundColor = [UIColor whiteColor];
    _bannerView.bannerContentMode = UIViewContentModeScaleAspectFit;
    _bannerView.dataSourceArray = imageURLs;
    _bannerView.delegate = self;
    [self.view addSubview:_bannerView];
    
    _label = [[UILabel alloc] init];
    _label.text = @"请点击轮播图图片";
    _label.backgroundColor = [UIColor whiteColor];
    _label.font = [UIFont systemFontOfSize:22.0];
    _label.textColor = [UIColor blackColor];
    _label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_label];
    
    
    _bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    id topLayoutGuide = self.topLayoutGuide;
    
    NSDictionary *bindingViews = @{@"bannerView": _bannerView, @"label": _label, @"topLayoutGuide": topLayoutGuide};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bannerView]-0-|" options:kNilOptions metrics:nil views:bindingViews]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide]-0-[bannerView]-100-[label(44)]" options:(NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight) metrics:nil views:bindingViews]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_bannerView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_bannerView
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:0.56 constant:0.0]];
}

#pragma mark - SGSBannerViewDelegate

- (void)tapedBannerView:(SGSBannerView *)banner withIndex:(NSUInteger)index {
    _label.text = [NSString stringWithFormat:@"点击了第 %lu 张图片", index+1];
}

@end
