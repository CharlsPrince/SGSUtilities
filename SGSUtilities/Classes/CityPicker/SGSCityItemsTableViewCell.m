/*!
 *  @file SGSCityItemsTableViewCell.m
 *
 *  @author Created by Lee on 16/10/21.
 *
 *  @copyright 2016年 SouthGIS. All rights reserved.
 */

#import "SGSCityItemsTableViewCell.h"
#import "SGSCityItemsCollectionViewCell.h"
#import "SGSCityPickerDefine.h"

static NSString * const kCityItemsCollectionViewCellIdentifier = @"CityItemsCollectionViewCell";

static const float kItemHeight = 35;
static const float kLineSpacing = 10;
static const float kInteritemSpacing = 10;

@interface SGSCityItemsTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *cityCollectionview;
@end

@implementation SGSCityItemsTableViewCell

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self setupSubviews];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)setupSubviews {
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize  = CGSizeMake([SGSCityItemsTableViewCell cityItemWidth], kItemHeight);
    flowLayout.minimumInteritemSpacing = kInteritemSpacing;
    flowLayout.minimumLineSpacing = kLineSpacing;
    flowLayout.sectionInset = UIEdgeInsetsZero;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _cityCollectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _cityCollectionview.dataSource = self;
    _cityCollectionview.delegate   = self;
    _cityCollectionview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _cityCollectionview.scrollEnabled   = NO;
    [_cityCollectionview registerClass:[SGSCityItemsCollectionViewCell class]
            forCellWithReuseIdentifier:kCityItemsCollectionViewCellIdentifier];
    
    [self.contentView addSubview:_cityCollectionview];
    
    CGFloat topPadding    = [SGSCityItemsTableViewCell topPadding];
    CGFloat bottomPadding = [SGSCityItemsTableViewCell bottomPadding];
    CGFloat horizontalPadding   = self.separatorInset.left;
    
    _cityCollectionview.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *bindingViews = @{@"cityCollectionview": _cityCollectionview};
    NSDictionary *metrics = @{@"top": @(topPadding), @"bottom": @(bottomPadding), @"left": @(horizontalPadding), @"right": @(horizontalPadding)};
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-left-[cityCollectionview]-right-|" options:kNilOptions metrics:metrics views:bindingViews]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(<=top)-[cityCollectionview]-(<=bottom)-|" options:kNilOptions metrics:metrics views:bindingViews]];
    
    [self layoutIfNeeded];
    
    [_cityCollectionview reloadData];
}

- (CGFloat)suggestedCellHeight {
    if ([_cities count] == 0) {
        return 1E-6;
    }
    
    // FIXME: 动态行高问题
    // 直接使用 _cityCollectionview.contentSize.height，在新增城市换行时行高显示不正确，必须再次刷新才能正确显示
    // 所以暂时使用计算的行高
    CGFloat collectionViewBoundsHeight = _cityCollectionview.contentSize.height;
    if (collectionViewBoundsHeight < 0.0001) {
        CGFloat screenWidth = SGSScreenWidth();
        CGFloat itemWidth = [SGSCityItemsTableViewCell cityItemWidth];
        NSInteger row = (NSInteger)ceilf([_cities count] / floorf(screenWidth / (itemWidth + kInteritemSpacing)));
        collectionViewBoundsHeight = row * kItemHeight;
        collectionViewBoundsHeight += (row-1) * kLineSpacing;
    }
    return (collectionViewBoundsHeight + [SGSCityItemsTableViewCell topPadding] + [SGSCityItemsTableViewCell bottomPadding]);
}

- (void)setCities:(NSArray<NSString *> *)cities {
    _cities = cities;
    [_cityCollectionview reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_cities count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SGSCityItemsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCityItemsCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.titleLabel.text = [_cities objectAtIndex:indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (_selectCityAction != nil) {
        _selectCityAction(indexPath.item);
    }
}

@end
