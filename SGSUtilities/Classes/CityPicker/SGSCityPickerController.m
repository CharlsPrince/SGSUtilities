/*!
 *  @file SGSCityPickerController.m
 *
 *  @author Created by Lee on 16/10/21.
 *
 *  @copyright 2016年 SouthGIS. All rights reserved.
 */

#import "SGSCityPickerController.h"
#import "SGSCityLocationTableViewCell.h"
#import "SGSCityItemsTableViewCell.h"
#import <CoreLocation/CoreLocation.h>

#pragma mark - 扩展类别

@interface NSArray (SGSCityPicker)
- (id)objectOrNilAtIndex:(NSUInteger)index;
@end

@implementation NSArray (SGSCityPicker)
- (id)objectOrNilAtIndex:(NSUInteger)index {
    return index < self.count ? self[index] : nil;
}
@end

@interface NSMutableArray (SGSCityPicker)
- (void)prependObject:(id)anObject;
@end

@implementation NSMutableArray (SGSCityPicker)
- (void)prependObject:(id)anObject {
    if (anObject != nil) {
        [self insertObject:anObject atIndex:0];
    }
}
@end

@interface NSDictionary (SGSCityPicker)
- (NSArray *)allKeysSorted;
+ (NSDictionary *)dictionaryForCityGroup;
@end

@implementation NSDictionary (SGSCityPicker)
- (NSArray *)allKeysSorted {
    return [self.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}
+ (NSDictionary *)dictionaryForCityGroup {
    NSBundle *bundle = [NSBundle bundleForClass:[SGSCityPickerController class]];
    NSURL *bundleURL = [bundle URLForResource:@"SGSCityPicker" withExtension:@"bundle"];
    bundle = [NSBundle bundleWithURL:bundleURL];
    NSString *path = [bundle pathForResource:@"CityList" ofType:@"plist"];
    if (path == nil) return nil;
    return [NSDictionary dictionaryWithContentsOfFile:path];
}
@end


#pragma mark - 城市数据源

static NSString * const kCurrentCityKey        = @"currentCity";
static NSString * const kVisitedHistoryCityKey = @"visitedHistoryCity";

@interface SGSCityEngine ()
+ (void)p_synchronizeVisitedHistory:(NSArray *)visitedHistory;
+ (void)p_synchronizeCurrentCity:(NSString *)currentCity;
@end

@implementation SGSCityEngine

+ (NSArray<NSString *> *)cityList {
    NSDictionary *cityGroup = [NSDictionary dictionaryForCityGroup];
    NSMutableArray *result = [NSMutableArray array];
    for (NSArray<NSString *> *cities in cityGroup.allValues) {
        [result addObjectsFromArray:cities];
    }
    return result;
}

+ (NSArray<NSString *> *)visitedHistory {
    return [[NSUserDefaults standardUserDefaults] arrayForKey:kVisitedHistoryCityKey];
}

+ (NSString *)currentCity {
    return [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentCityKey];
}

+ (void)clearVisitedHistory {
    [self p_synchronizeVisitedHistory:nil];
}

+ (void)clearCurrentCity {
    [self p_synchronizeCurrentCity:nil];
}

+ (void)p_synchronizeVisitedHistory:(NSArray *)visitedHistory {
    [[NSUserDefaults standardUserDefaults] setObject:visitedHistory forKey:kVisitedHistoryCityKey];
}

+ (void)p_synchronizeCurrentCity:(NSString *)currentCity {
    [[NSUserDefaults standardUserDefaults] setObject:currentCity forKey:kCurrentCityKey];
}

@end



///=============================================================================
///  MARK: 城市搜索结果
///=============================================================================

/// 用于展示城市搜索结果
@interface SGSCitySearchResultsController : UITableViewController
@property (nonatomic, strong, readonly) NSArray<NSMutableAttributedString *> *dataSource;
- (void)reloadWithDataSource:(NSArray<NSMutableAttributedString *> *)dataSource;
@end

@implementation SGSCitySearchResultsController {
    NSArray<NSMutableAttributedString *> *_dataSource;
}

- (NSArray<NSMutableAttributedString *> *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)reloadWithDataSource:(NSArray<NSMutableAttributedString *> *)dataSource {
    _dataSource = dataSource;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ([_dataSource count] == 0 ? 1 : [_dataSource count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if ([_dataSource count] == 0) {
        cell.textLabel.text = @"抱歉，未找到相关城市";
    } else {
        cell.textLabel.attributedText = [_dataSource objectOrNilAtIndex:indexPath.row];
    }
    
    return cell;
}

@end




///=============================================================================
///  MARK: 城市列表
///=============================================================================

/// 用于展示当前定位城市、最近访问城市、热门城市、城市列表
@interface SGSCityListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,
CLLocationManagerDelegate, UISearchResultsUpdating>
@property (nonatomic, strong) UIColor *sectionIndexColor;
@property (nullable, nonatomic, strong) NSArray<NSString *> *hotCities;
@property (nullable, nonatomic, copy) NSString *cancelItemTitle;
@property (nullable, nonatomic, strong) UIImage *cancelItemIcon;
@property (nullable, nonatomic, weak) id<SGSCityPickerControllerDelegate> pickerDelegate;
@end


static NSString * const kCurrentCityCellIdentifier    = @"CurrentCityCell";
static NSString * const kLocationCellIdentifier       = @"LocationCell";
static NSString * const kVisitedHistoryCellIdentifier = @"VisitedHistoryCell";
static NSString * const kHotCitiesCellIdentifier      = @"HotCitiesCell";
static NSString * const kCityCellIdentifier           = @"CityCell";

static int const kCurrentCityCellIndex    = 0;
static int const kLocationCellIndex       = 1;
static int const kVisitedHistoryCellIndex = 2;
static int const kHotCitiesCellIndex      = 3;

typedef NS_ENUM(NSInteger, LocationStatus) {
    LocationStatusPreparation = 0,  //! 定位准备阶段
    LocationStatusNotAuthorized,    //! 用户未授权定位
    LocationStatusPositioning,      //! 定位中
    LocationStatusFinished,         //! 定位完毕
    LocationStatusFailure,          //! 定位失败
};

@implementation SGSCityListViewController {
    UITableView *_tableView;
    LocationStatus _locationStatus;      //! 定位状态
    NSString *_locationCity;             //! 定位城市
    CLLocationManager *_locationManager; //! 定位管理
    
    NSMutableArray<NSString *> *_sectionIndexs;    //! 索引
    NSDictionary<NSString *, NSArray<NSString *>*> *_cityGroup; //! 城市分组
    NSMutableArray<NSString *> *_cityList;         //! 所有城市的列表
    NSMutableArray<NSString *> *_visitedHistory;   //! 最近访问城市，最多记录6个
    
    SGSCitySearchResultsController *_searchResultsController; //! 搜索结果视图控制器
    UISearchController *_searchController;         //! 搜索控制器
    NSMutableArray<NSNumber *> *_cellHeightRecord; //! 记录Cell高度
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.definesPresentationContext = YES;
    
    [self fetchCities];
    
    [self setupSubviews];
    
    NSString *itemTitle = (!_cancelItemTitle && !_cancelItemIcon) ? @"取消" : _cancelItemTitle;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:itemTitle style:UIBarButtonItemStylePlain target:self action:@selector(cancelItemClicked:)];
    self.navigationItem.leftBarButtonItem.image = _cancelItemIcon;
    
    self.navigationItem.title = @"选择城市";
    
    [self location];
    
    [_tableView reloadData];
}



// 获取城市列表
- (void)fetchCities {
    _cityGroup = [NSDictionary dictionaryForCityGroup];
    
    _sectionIndexs = [NSMutableArray arrayWithObjects:UITableViewIndexSearch, @"定位", @"历史", @"热门", nil];
    [_sectionIndexs addObjectsFromArray:_cityGroup.allKeysSorted];
    
    _cityList = [NSMutableArray array];
    for (NSArray<NSString *> *cities in _cityGroup.allValues) {
        [_cityList addObjectsFromArray:cities];
    }
    
    NSArray *history = [SGSCityEngine visitedHistory];
    
    if (history != nil) {
        _visitedHistory = [NSMutableArray arrayWithArray:history];
    } else {
        _visitedHistory = [NSMutableArray array];
    }
    
    if (_hotCities == nil) {
        _hotCities = @[@"北京", @"上海", @"广州", @"深圳"];
    }
}

// 设置子视图
- (void)setupSubviews {
    _cellHeightRecord = [NSMutableArray arrayWithObjects: @(44.0),
                         @([SGSCityLocationTableViewCell suggestedCellHeight]), @(0.0001), @(0.0001), nil];
    
    _searchResultsController =  [[SGSCitySearchResultsController alloc] initWithStyle:UITableViewStylePlain];
    _searchResultsController.tableView.delegate = self;
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:_searchResultsController];
    _searchController.searchResultsUpdater = self;
    
    UISearchBar *searchBar = _searchController.searchBar;
    searchBar.placeholder = @"搜索城市";
    [searchBar sizeToFit];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.tableHeaderView = searchBar;
    _tableView.sectionIndexColor = _sectionIndexColor;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[UITableViewCell class]
       forCellReuseIdentifier:kCurrentCityCellIdentifier];
    [_tableView registerClass:[SGSCityLocationTableViewCell class]
       forCellReuseIdentifier:kLocationCellIdentifier];
    [_tableView registerClass:[SGSCityItemsTableViewCell class]
       forCellReuseIdentifier:kVisitedHistoryCellIdentifier];
    [_tableView registerClass:[SGSCityItemsTableViewCell class]
       forCellReuseIdentifier:kHotCitiesCellIdentifier];
    [_tableView registerClass:[UITableViewCell class]
       forCellReuseIdentifier:kCityCellIdentifier];
}

- (void)location {
    _locationStatus = LocationStatusPreparation;
    _locationCity = nil;
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    if ([CLLocationManager locationServicesEnabled]) {
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusRestricted: // 用户之前拒绝获取权限
            case kCLAuthorizationStatusDenied: {
                [self updateLocationStatus:LocationStatusNotAuthorized withLocationCity:nil];
            } break;
                
            default: {
                if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                    // 申请定位权限
                    [_locationManager requestWhenInUseAuthorization];
                }
                [_locationManager startUpdatingLocation];
                [self updateLocationStatus:LocationStatusPositioning withLocationCity:nil];
            } break;
        }
    } else {
        [self updateLocationStatus:LocationStatusFailure withLocationCity:nil];
    }
}

// 获取定位信息
- (NSString *)locationMessage {
    switch (_locationStatus) {
        case LocationStatusPreparation: return nil;
        case LocationStatusNotAuthorized: return @"点击获取定位信息";
        case LocationStatusPositioning: return @"正在定位中...";
        case LocationStatusFinished: return _locationCity;
        case LocationStatusFailure: return @"定位失败，点击重新获取定位信息";
    }
}

// 更新定位状态
- (void)updateLocationStatus:(LocationStatus)status withLocationCity:(NSString *)city {
    _locationStatus = status;
    _locationCity = city;
    [_tableView reloadData];
}

// 选择城市
- (void)didSelectCity:(NSString *)cityName {
    if (cityName == nil) return;
    
    if ([_visitedHistory containsObject:cityName]) {
        [_visitedHistory removeObject:cityName];
    } else if (_visitedHistory.count == 6) { // 最大限制记录6个城市
        [_visitedHistory removeLastObject];
    }
    
    [_visitedHistory prependObject:cityName];
    
    [SGSCityEngine p_synchronizeVisitedHistory:_visitedHistory];
    [SGSCityEngine p_synchronizeCurrentCity:cityName];

    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    
    if ([_pickerDelegate respondsToSelector:@selector(sgsCityPickerController:didFinishPickingCity:)]) {
        [_pickerDelegate sgsCityPickerController:(SGSCityPickerController *)self.navigationController didFinishPickingCity:cityName];
    }
}

#pragma mark - Actions

// 点击返回按钮
- (void)cancelItemClicked:(UIBarButtonItem *)item {
    if ([_pickerDelegate respondsToSelector:@selector(sgsCityPickerControllerDidCancel:)]) {
        [_pickerDelegate sgsCityPickerControllerDidCancel:(SGSCityPickerController *)self.navigationController];
    }
}

// 跳转到系统设置
- (void)gotoAppSetting {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    UIApplication *app = [UIApplication sharedApplication];
    if ([app respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [app openURL:url options:@{} completionHandler:nil];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [app openURL:url];
#pragma clang diagnostic pop
    }
}

// 提示允许定位
- (void)showLocaltionAuthorizedPromptPanel {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"获取定位服务" message:@"请在系统设置中允许使用定位服务" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self gotoAppSetting];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

// 提示开启定位服务
- (void)showSettingLocationServicePromptPanel {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"未开启定位服务" message:@"请在系统设置中开启定位服务" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"开启定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self gotoAppSetting];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

// 点击当前定位城市按钮
- (void)locationButtonClicked:(UIButton *)sender {
    switch (_locationStatus) {
        case LocationStatusPreparation:
        case LocationStatusFailure: {
            if ([CLLocationManager locationServicesEnabled]) {
                [_locationManager startUpdatingLocation];
                [self updateLocationStatus:LocationStatusPositioning withLocationCity:nil];
            } else {
                [self showSettingLocationServicePromptPanel];
            }
        } break;
            
        case LocationStatusNotAuthorized : {
            [self showLocaltionAuthorizedPromptPanel];
        } break;
            
        case LocationStatusFinished: {
            [self didSelectCity:_locationCity];
        } break;
            
        case LocationStatusPositioning: break;
    }
}

// 选择最近访问城市
- (void)selectedVisitedHistoryCiryAtIndex:(NSInteger)index {
    if ((index >= 0) && (index < [_visitedHistory count])) {
        [self didSelectCity:_visitedHistory[index]];
    }
}

// 选择热门城市
- (void)selectedHotCityAtIndex:(NSInteger)index {
    if ((index >= 0) && (index < [_hotCities count])) {
        [self didSelectCity:_hotCities[index]];
    }
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: { // 用户未授权
            // 在程序运行期间允许访问位置数据
            if ([manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [manager requestWhenInUseAuthorization];
            }
        } break;
            
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse: {
            if ((_locationStatus == LocationStatusPreparation) ||
                (_locationStatus == LocationStatusNotAuthorized)) {
                [manager startUpdatingLocation];
                [self updateLocationStatus:LocationStatusPositioning withLocationCity:nil];
            }
        } break;
            
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [manager stopUpdatingLocation];
    
    if (locations.count == 0) {
        [self updateLocationStatus:LocationStatusFailure withLocationCity:nil];
    } else {
        // 地理反编码
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        
        [geocoder reverseGeocodeLocation:locations.firstObject completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            NSString *city = [placemarks.firstObject locality];
            if (city == nil) {
                [self updateLocationStatus:LocationStatusFailure withLocationCity:nil];
            } else {
                for (NSString *shortCityName in _cityList) {
                    if (([city rangeOfString:shortCityName].length > 0)) {
                        city = shortCityName;
                        break;
                    }
                }
                [self updateLocationStatus:LocationStatusFinished withLocationCity:city];
            }
        }];
    }
}

// 定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [manager stopUpdatingLocation];
    [self updateLocationStatus:LocationStatusFailure withLocationCity:nil];
}

#pragma mark - UISearchResultsUpdating

// 刷新搜索结果视图
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *keyword = searchController.searchBar.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", keyword];
    NSArray *searchResult = [_cityList filteredArrayUsingPredicate:predicate];
    
    NSMutableArray *searchResultDataSource = [NSMutableArray arrayWithCapacity:searchResult.count];
    NSDictionary *textAttribute = @{NSForegroundColorAttributeName: [UIColor redColor]};
    
    for (NSString *city in searchResult) {
        NSRange range = [city rangeOfString:keyword];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:city];
        [attrStr setAttributes:textAttribute range:range];
        [searchResultDataSource addObject:attrStr];
    }
    
    [(SGSCitySearchResultsController *)searchController.searchResultsController reloadWithDataSource:searchResultDataSource];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionIndexs.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < 4) {
        return 1;
    } else {
        NSString *key = _sectionIndexs[section];
        NSArray *cities = _cityGroup[key];
        return [cities count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section < 4) {
        switch (section) {
            case kCurrentCityCellIndex: return nil;
            case kLocationCellIndex: return @"当前定位城市";
            case kVisitedHistoryCellIndex: return @"最近访问城市";
            case kHotCitiesCellIndex: return @"热门城市";
            default: break;
        }
    }
    
    return [_sectionIndexs objectOrNilAtIndex:section];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _sectionIndexs;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (index == 0) {
        // 第一个搜索图标对应搜索栏
        [tableView scrollRectToVisible:_searchController.searchBar.frame animated:NO];
        return -1;
    }
    return index;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case kCurrentCityCellIndex: // 当前城市
            return [self currentCityCellFromTableView:tableView forIndexPath:indexPath];
            
        case kLocationCellIndex: // 当前定位
            return [self locationCellFromTableView:tableView forIndexPath:indexPath];
            
        case kVisitedHistoryCellIndex: // 最近访问城市
            return [self visitedHistoryCellFromTableView:tableView forIndexPath:indexPath];
            
        case kHotCitiesCellIndex: // 热门城市
            return [self hotCitiesCellFromTableView:tableView forIndexPath:indexPath];
            
        default: // 城市列表
            return [self cityCellFromTableView:tableView forIndexPath:indexPath];
    }
}

// 当前城市cell
- (UITableViewCell *)currentCityCellFromTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCurrentCityCellIdentifier forIndexPath:indexPath];
    NSString *currentCity = [SGSCityEngine currentCity];
    if (currentCity == nil) currentCity = @"";
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.textLabel.text = [NSString stringWithFormat:@"当前城市：%@", currentCity];
    
    return cell;
}

// 当前定位城市cell
- (UITableViewCell *)locationCellFromTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath {
    SGSCityLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLocationCellIdentifier forIndexPath:indexPath];
    [cell.locationButton addTarget:self action:@selector(locationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell setLocationButtonTitle:[self locationMessage]];
    
    return cell;
}

// 最近访问城市cell
- (UITableViewCell *)visitedHistoryCellFromTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath {
    SGSCityItemsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kVisitedHistoryCellIdentifier forIndexPath:indexPath];

    __weak typeof(&*self) weakSelf = self;
    [cell setSelectCityAction:^(NSInteger index) {
        [weakSelf selectedVisitedHistoryCiryAtIndex:index];
    }];
    [cell setCities:_visitedHistory];
    _cellHeightRecord[kVisitedHistoryCellIndex] = @(cell.suggestedCellHeight);
    
    return cell;
}

// 配置热门城市cell
- (UITableViewCell *)hotCitiesCellFromTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath {
    SGSCityItemsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHotCitiesCellIdentifier forIndexPath:indexPath];

    __weak typeof(&*self) weakSelf = self;
    [cell setSelectCityAction:^(NSInteger index) {
        [weakSelf selectedHotCityAtIndex:index];
    }];
    [cell setCities:_hotCities];
    _cellHeightRecord[kHotCitiesCellIndex] = @(cell.suggestedCellHeight);
    
    return cell;
}

// 配置城市列表cell
- (UITableViewCell *)cityCellFromTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCityCellIdentifier forIndexPath:indexPath];
    NSString *key = _sectionIndexs[indexPath.section];
    NSArray *cities = _cityGroup[key];
    NSInteger index = indexPath.row;
    if ((index >= 0) && (index < [cities count])) {
        cell.textLabel.text = [cities objectOrNilAtIndex:index];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

// 选择城市
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == _tableView) {
        NSInteger section = indexPath.section;
        if (section >= 4) {
            NSString *key = _sectionIndexs[section];
            NSArray *cities = _cityGroup[key];
            NSInteger index = indexPath.row;
            if ((index >= 0) && (index < cities.count)) {
                NSString *city = [cities objectOrNilAtIndex:index];
                [self didSelectCity:city];
            }
        }
    } else {
        NSString *city = [[_searchResultsController.dataSource objectOrNilAtIndex:indexPath.row] string];
        if (city != nil) {
            [_searchResultsController dismissViewControllerAnimated:NO completion:nil];
            [self didSelectCity:city];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section > 0) && (indexPath.section < 4)) {
        return [_cellHeightRecord[indexPath.section] floatValue];
    } else {
        return 44.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass: [UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
        header.textLabel.textColor = [UIColor grayColor];
        header.textLabel.font = [UIFont systemFontOfSize:15.0];
        if (section < 4) {
            header.tintColor = [UIColor groupTableViewBackgroundColor];
        }
    }
}

#pragma mark - Accessors

- (void)setCancelItemTitle:(NSString *)cancelItemTitle {
    _cancelItemTitle = cancelItemTitle.copy;
    if (self.navigationItem.leftBarButtonItem != nil) {
        self.navigationItem.leftBarButtonItem.title = _cancelItemTitle;
    }
}

- (void)setCancelItemIcon:(UIImage *)cancelItemIcon {
    _cancelItemIcon = cancelItemIcon;
    if (self.navigationItem.leftBarButtonItem != nil) {
        self.navigationItem.leftBarButtonItem.image = _cancelItemIcon;
    }
}

@end


///=============================================================================
///  MARK: 城市选择控制器
///=============================================================================

@implementation SGSCityPickerController

- (BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}


#pragma mark - initialize

+ (instancetype)cityPickerController {
    SGSCityListViewController *cityListVC = [[SGSCityListViewController alloc] init];
    SGSCityPickerController *result = [[SGSCityPickerController alloc] initWithRootViewController:cityListVC];
    return result;
}

#pragma mark - Accessors

- (SGSCityListViewController *)cityListViewController {
    return self.viewControllers.firstObject;
}

- (void)setHotCities:(NSArray<NSString *> *)hotCities {
    [[self cityListViewController] setHotCities:hotCities];
}

- (NSArray<NSString *> *)hotCities {
    return [[self cityListViewController] hotCities];
}

- (void)setSectionIndexColor:(UIColor *)sectionIndexColor {
    [[self cityListViewController] setSectionIndexColor:sectionIndexColor];
}

- (UIColor *)sectionIndexColor {
    return [[self cityListViewController] sectionIndexColor];
}

- (void)setCancelItemTitle:(NSString *)cancelItemTitle {
    [[self cityListViewController] setCancelItemTitle:cancelItemTitle];
}

- (NSString *)cancelItemTitle {
    return [[self cityListViewController] cancelItemTitle];
}

- (void)setCancelItemIcon:(UIImage *)cancelItemIcon {
    [[self cityListViewController] setCancelItemIcon:cancelItemIcon];
}

- (UIImage *)cancelItemIcon {
    return [[self cityListViewController] cancelItemIcon];
}

- (void)setPickerDelegate:(id<UINavigationControllerDelegate, SGSCityPickerControllerDelegate>)pickerDelegate {
    self.delegate = pickerDelegate;
    [[self cityListViewController] setPickerDelegate:pickerDelegate];
}


@end
