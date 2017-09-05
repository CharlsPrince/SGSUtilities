//
//  LoadImageViewController.m
//  SGSUtilities
//
//  Created by Lee on 16/11/3.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "LoadImageViewController.h"
#import <SGSUtilities/UIImageView+SGSImageLoad.h>
#import "LoadImageTableViewCell.h"

@interface LoadImageViewController ()
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UIImage *placeholder;
@end

@implementation LoadImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _placeholder = [UIImage imageNamed:@"icon_512"];
}

- (NSArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = @[@"http://img.pconline.com.cn/images/upload/upc/tx/photoblog/1406/22/c6/35549943_35549943_1403434818762_mthumb.jpg",
                        @"http://desk.fd.zol-img.com.cn/t_s960x600c5/g4/M01/0D/04/Cg-4WVP_npmIY6GRAKcKYPPMR3wAAQ8LgNIuTMApwp4015.jpg",
                        @"http://desk.fd.zol-img.com.cn/t_s960x600c5/g5/M00/00/0A/ChMkJ1ecZb2IQdT8AATJRtrzV70AAT_1gNHoPkABMle872.jpg",
                        @"http://desk.fd.zol-img.com.cn/t_s960x600c5/g5/M00/01/0E/ChMkJlbKwhKIPf_RAAweZKvhDqMAALGiQLPZ9QADB58872.jpg",
                        @"http://desk.fd.zol-img.com.cn/t_s960x600c5/g5/M00/02/06/ChMkJ1bKyqKIPFxLAGZe49gDZ3YAALIegJkT54AZl77897.jpg",
                        @"http://image101.360doc.com/DownloadImg/2016/10/2719/83195451_2.jpg",
                        // progressive jpeg
                        @"https://s-media-cache-ak0.pinimg.com/1200x/2e/0c/c5/2e0cc5d86e7b7cd42af225c29f21c37f.jpg",
                        
                        // animated gif: http://cinemagraphs.com/
                        @"http://i.imgur.com/uoBwCLj.gif",
                        @"http://i.imgur.com/8KHKhxI.gif",
                        @"http://i.imgur.com/WXJaqof.gif",
                        
                        // animated gif: https://dribbble.com/markpear
                        @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1780193/dots18.gif",
                        @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1809343/dots17.1.gif",
                        @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1845612/dots22.gif",
                        @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1820014/big-hero-6.gif",
                        @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1819006/dots11.0.gif",
                        @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1799885/dots21.gif",
                        
                        // animaged gif: https://dribbble.com/jonadinges
                        @"https://d13yacurqjgara.cloudfront.net/users/288987/screenshots/2025999/batman-beyond-the-rain.gif",
                        @"https://d13yacurqjgara.cloudfront.net/users/288987/screenshots/1855350/r_nin.gif",
                        @"https://d13yacurqjgara.cloudfront.net/users/288987/screenshots/1963497/way-back-home.gif",
                        @"https://d13yacurqjgara.cloudfront.net/users/288987/screenshots/1913272/depressed-slurp-cycle.gif",
                        
                        // jpg: https://dribbble.com/snootyfox
                        @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2047158/beerhenge.jpg",
                        @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2016158/avalanche.jpg",
                        @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1839353/pilsner.jpg",
                        @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1833469/porter.jpg",
                        @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1521183/farmers.jpg",
                        @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1391053/tents.jpg",
                        @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1399501/imperial_beer.jpg",
                        @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1488711/fishin.jpg",
                        @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1466318/getaway.jpg",
                        
                        // animated webp and apng: http://littlesvr.ca/apng/gif_apng_webp.html
                        @"http://littlesvr.ca/apng/images/BladeRunner.png",
                        @"http://littlesvr.ca/apng/images/Contact.webp",
                        ];
    }
    return _dataSource;
}
- (IBAction)clearCache:(UIBarButtonItem *)sender {
    [[SGSImageCache defaultImageCache] removeAllCachedImage];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LoadImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoadImageCell" forIndexPath:indexPath];
    NSURL *url = [NSURL URLWithString:self.dataSource[indexPath.row]];
    [cell.webImageView setImageWithURL:url placeholder:_placeholder];
    return cell;
}

@end
