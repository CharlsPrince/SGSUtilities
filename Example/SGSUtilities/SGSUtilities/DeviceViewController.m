/*!
 @header DeviceViewController.m
  
 @author Created by Lee on 16/9/12.
 
 @copyright 2016年 SouthGIS. All rights reserved.
 
 */

#import "DeviceViewController.h"
#import <SGSUtilities/SGSDeviceUtil.h>

@interface DeviceViewController ()

@end

@implementation DeviceViewController

- (void)screenCell:(UITableViewCell *)cell row:(NSInteger)row {
    NSString *title = nil;
    NSString *msg = nil;
    
    switch (row) {
        case 0:
            title = @"屏幕等级";
            msg = @([SGSDeviceUtil screenScale]).description;
            break;
        case 1:
            title = @"屏幕尺寸";
            msg = NSStringFromCGSize([SGSDeviceUtil screenSize]);
            break;
        case 2:
            title = @"屏幕宽度";
            msg = @([SGSDeviceUtil screenWidth]).description;
            break;
        case 3:
            title = @"屏幕高度";
            msg = @([SGSDeviceUtil screenHeight]).description;
            break;
        case 4:
            title = @"屏幕分辨率";
            msg = NSStringFromCGSize([SGSDeviceUtil sizeInPixel]);
            break;
        case 5:
            title = @"屏幕像素";
            msg = @([SGSDeviceUtil pixelsPerInch]).description;
            break;
        case 6:
            title = @"当前屏幕范围";
            msg = NSStringFromCGRect([SGSDeviceUtil currentScreenBounds]);
            break;
        case 7:
            title = @"是否为竖屏";
            msg = [SGSDeviceUtil isPortrait] ? @"YES" : @"NO";
            break;
        case 8:
            title = @"是否为横屏";
            msg = [SGSDeviceUtil isLandscape] ? @"YES" : @"NO";
            break;
        default:
            break;
    }
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = msg;
}

- (void)deviceInfoCell:(UITableViewCell *)cell row:(NSInteger)row {
    NSString *title = nil;
    NSString *msg = nil;
    
    switch (row) {
        case 0:
            title = @"设备名称";
            msg = [SGSDeviceUtil deviceName];
            break;
        case 1:
            title = @"系统名称";
            msg = [SGSDeviceUtil systemName];
            break;
        case 2:
            title = @"设备型号";
            msg = [SGSDeviceUtil machineModel];
            break;
        case 3:
            title = @"设备型号名称";
            msg = [SGSDeviceUtil machineModelName];
            break;
        case 4:
            title = @"UUID";
            msg = [SGSDeviceUtil UUID];
            break;
        case 5:
            title = @"国家";
            msg = [NSString stringWithFormat:@"%@ (%@)", [SGSDeviceUtil localeCountryCode],
             [SGSDeviceUtil localeCountry]];
            break;
        case 6:
            title = @"语言";
            msg = [NSString stringWithFormat:@"%@ (%@)", [SGSDeviceUtil preferredLanguageCode],
                   [SGSDeviceUtil preferredLanguage]];
            break;
        case 7:
            title = @"运营商";
            msg = [SGSDeviceUtil carrierName];
            break;
        case 8:
            title = @"系统版本";
            msg = [SGSDeviceUtil systemVersion];
            break;
        case 9:
            title = @">= iOS 7.0 ?";
            msg = [SGSDeviceUtil iOS7OrLater] ? @"YES" : @"NO";
            break;
        case 10:
            title = @">= iOS 8.0 ?";
            msg = [SGSDeviceUtil iOS8OrLater] ? @"YES" : @"NO";
            break;
        case 11:
            title = @">= iOS 9.0 ?";
            msg = [SGSDeviceUtil iOS9OrLater] ? @"YES" : @"NO";
            break;
        default:
            break;
    }
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = msg;
}

- (void)diskCell:(UITableViewCell *)cell row:(NSInteger)row {
    NSString *title = nil;
    NSString *msg = nil;
    
    switch (row) {
        case 0:
            title = @"磁盘总大小";
            msg = [NSByteCountFormatter stringFromByteCount:[SGSDeviceUtil diskSpaceTotal] countStyle:NSByteCountFormatterCountStyleBinary];
            break;
        case 1:
            title = @"可用磁盘大小";
            msg = [NSByteCountFormatter stringFromByteCount:[SGSDeviceUtil diskSpaceFree] countStyle:NSByteCountFormatterCountStyleBinary];
            break;
        case 2:
            title = @"磁盘已使用空间";
            msg = [NSByteCountFormatter stringFromByteCount:[SGSDeviceUtil diskSpaceUsed] countStyle:NSByteCountFormatterCountStyleBinary];
            break;
        default:
            break;
    }
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = msg;
}

- (void)memoryCell:(UITableViewCell *)cell row:(NSInteger)row {
    NSString *title = nil;
    NSString *msg = nil;
    
    switch (row) {
        case 0:
            title = @"物理内存总大小";
            msg = [NSByteCountFormatter stringFromByteCount:[SGSDeviceUtil memoryTotal] countStyle:NSByteCountFormatterCountStyleBinary];
            break;
        case 1:
            title = @"空闲内存大小";
            msg = [NSByteCountFormatter stringFromByteCount:[SGSDeviceUtil memoryFree] countStyle:NSByteCountFormatterCountStyleBinary];
            break;
        case 2:
            title = @"已使用内存大小";
            msg = [NSByteCountFormatter stringFromByteCount:[SGSDeviceUtil memoryUsed] countStyle:NSByteCountFormatterCountStyleBinary];
            break;
        default:
            break;
    }
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = msg;
}

- (void)cpuCell:(UITableViewCell *)cell row:(NSInteger)row {
    NSString *title = nil;
    NSString *msg = nil;
    
    switch (row) {
        case 0:
            title = @"CPU核数";
            msg = [NSString stringWithFormat:@"%lu", [SGSDeviceUtil processorCount]];
            break;
        case 1:
            title = @"CPU可用核数";
            msg = [NSString stringWithFormat:@"%lu", [SGSDeviceUtil activeProcessorCount]];
            break;
        case 2:
            title = @"当前进程名";
            msg = [SGSDeviceUtil processName];
            break;
        case 3:
            title = @"CPU 使用状况";
            msg = [NSString stringWithFormat:@"%.2lf%%", [SGSDeviceUtil cpuUsage] * 100];
            break;
        default:
            break;
    }
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = msg;
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 9;
        case 1: return 12;
        case 2: return 3;
        case 3: return 3;
        case 4: return 4;
        default: return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: return @"屏幕";
        case 1: return @"设备基本信息和系统版本";
        case 2: return @"磁盘空间";
        case 3: return @"内存状况";
        case 4: return @"CPU状况";
        default: return nil;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceCell" forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0: [self screenCell:cell row:indexPath.row]; break;
        case 1: [self deviceInfoCell:cell row:indexPath.row]; break;
        case 2: [self diskCell:cell row:indexPath.row]; break;
        case 3: [self memoryCell:cell row:indexPath.row]; break;
        case 4: [self cpuCell:cell row:indexPath.row]; break;
        default: break;
    }
    
    return cell;
}



@end
