/*!
 @header NetViewController.m
  
 @author Created by Lee on 16/9/12.
 
 @copyright 2016年 SouthGIS. All rights reserved.
 
 */

#import "NetViewController.h"
#import <SGSUtilities/SGSNetUtil.h>

@interface NetViewController ()
@property (nonatomic, assign) BOOL firstLoad;
@end

@implementation NetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _firstLoad = YES;
    
    // 开始监听网络状态
    [[SGSNetUtil sharedInstance] startMonitoring];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusDidChange:) name:SGSNetReachabilityDidChangedNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)networkStatusDidChange:(NSNotification *)sender {
    if (_firstLoad) {
        _firstLoad = NO;
        return;
    }
    
    SGSNetworkStatus status = [sender.userInfo[SGSNetReachabilityNotificationStatusKey] integerValue];
    
    NSString *msg = nil;
    switch (status) {
        case SGSNetworkStatusNotReachable:
            msg = @"没有网络";
            break;
        case SGSNetworkStatusReachableViaWiFi:
            msg = @"WiFi";
            break;
        case SGSNetworkStatusReachableViaWWAN2G:
            msg = @"2G网络";
            break;
        case SGSNetworkStatusReachableViaWWAN3G:
            msg = @"3G网络";
            break;
        case SGSNetworkStatusReachableViaWWAN4G:
            msg = @"4G网络";
            break;
        case SGSNetworkStatusUnknown:
        default:
            msg = @"未知网络环境";
            break;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络状态发生改变" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
    [self.tableView reloadData];
}

- (void)staticNetworkReachabilityCell:(UITableViewCell *)cell row:(NSInteger)row {
    switch (row) {
        case 0:
            cell.textLabel.text = @"是否连接到网络";
            cell.detailTextLabel.text = [SGSNetUtil isReachable] ? @"YES" : @"NO";
            break;
        case 1:
            cell.textLabel.text = @"当前网络环境是 WiFi ?";
            cell.detailTextLabel.text = [SGSNetUtil isReachableViaWiFi] ? @"YES" : @"NO";
            break;
        case 2:
            cell.textLabel.text = @"当前网络环境是蜂窝网络?";
            cell.detailTextLabel.text = [SGSNetUtil isReachableViaWWAN] ? @"YES" : @"NO";
            break;
        case 3:
            cell.textLabel.text = @"当前网络环境是2G网络?";
            cell.detailTextLabel.text = [SGSNetUtil isReachableViaWWAN2G] ? @"YES" : @"NO";
            break;
        case 4:
            cell.textLabel.text = @"当前网络环境是3G网络?";
            cell.detailTextLabel.text = [SGSNetUtil isReachableViaWWAN3G] ? @"YES" : @"NO";
            break;
        case 5:
            cell.textLabel.text = @"当前网络环境是4G网络?";
            cell.detailTextLabel.text = [SGSNetUtil isReachableViaWWAN4G] ? @"YES" : @"NO";
            break;
        default:
            break;
    }
}

- (void)networkReachabilityCell:(UITableViewCell *)cell row:(NSInteger)row {
    SGSNetUtil *util = [SGSNetUtil sharedInstance];
    
    switch (row) {
        case 0:
            cell.textLabel.text = @"当前网络状态";
            cell.detailTextLabel.text = [util localizedNetworkReachabilityStatusString];
            break;
        case 1:
            cell.textLabel.text = @"是否连接到网络";
            cell.detailTextLabel.text = util.isReachable ? @"YES" : @"NO";
            break;
        case 2:
            cell.textLabel.text = @"当前网络环境是 WiFi ?";
            cell.detailTextLabel.text = util.isReachableViaWiFi ? @"YES" : @"NO";
            break;
        case 3:
            cell.textLabel.text = @"当前网络环境是蜂窝网络?";
            cell.detailTextLabel.text = util.isReachableViaWWAN ? @"YES" : @"NO";
            break;
        case 4:
            cell.textLabel.text = @"当前网络环境是2G网络?";
            cell.detailTextLabel.text = util.isReachableViaWWAN2G ? @"YES" : @"NO";
            break;
        case 5:
            cell.textLabel.text = @"当前网络环境是3G网络?";
            cell.detailTextLabel.text = util.isReachableViaWWAN3G ? @"YES" : @"NO";
            break;
        case 6:
            cell.textLabel.text = @"当前网络环境是4G网络?";
            cell.detailTextLabel.text = util.isReachableViaWWAN4G ? @"YES" : @"NO";
            break;
        default:
            break;
    }
}

- (void)ipAddressCell:(UITableViewCell *)cell row:(NSInteger)row {
    switch (row) {
        case 0:
            cell.textLabel.text = @"IP 地址";
            cell.detailTextLabel.text = [SGSNetUtil ipAddress];
            break;
        case 1:
            cell.textLabel.text = @"WiFi IP 地址";
            cell.detailTextLabel.text = [SGSNetUtil ipAddressForWiFi];
            break;
        case 2:
            cell.textLabel.text = @"蜂窝网络 IP 地址";
            cell.detailTextLabel.text = [SGSNetUtil ipAddressForWWAN];
            break;
        default:
            break;
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 6;
        case 1: return 7;
        case 2: return 3;
        default: return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NetCell" forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
            [self staticNetworkReachabilityCell:cell row:indexPath.row];
            break;
        case 1:
            [self networkReachabilityCell:cell row:indexPath.row];
            break;
        case 2:
            [self ipAddressCell:cell row:indexPath.row];
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: return @"静态网络状态";
        case 1: return @"动态网络状态";
        case 2: return @"IP 地址";
        default: return nil;
    }
}


@end
