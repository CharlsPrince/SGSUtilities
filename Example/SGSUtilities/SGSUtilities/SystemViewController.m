/*!
 @header SystemViewController.m
 
 @author Created by Lee on 16/9/8.
 
 @copyright 2016年 SouthGIS. All rights reserved.
 
 */

#import "SystemViewController.h"
#import <SGSUtilities/SGSMacros.h>
#import <SGSUtilities/SGSSystemUtil.h>

@interface SystemViewController ()
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *apps;
@end

@implementation SystemViewController

#pragma mark - getter & setter

- (NSArray *)apps {
    return Lazy(_apps, @[@"打开浏览器", @"打开QQ", @"打开微信", @"打开新浪微博",
                         @"打开腾讯微博", @"打开支付宝", @"打开淘宝", @"打开天猫",
                         @"打开京东", @"打开京东HD（iPad）", @"打开美团", @"打开百度地图",
                         @"打开高德地图", @"打开腾讯地图"]);
}

- (NSArray *)titles {
    return Lazy(_titles, @[@"拨打电话", @"发送短信", @"发送邮件", @"跳转到应用设置",
                           @"跳转到WIFI设置", @"跳转到蓝牙设置", @"跳转到通知中心设置",
                           @"跳转到系统通用设置", @"跳转到关于本机设置", @"跳转到软件更新",
                           @"跳转到SIRI设置", @"跳转到辅助功能设置", @"跳转到自动锁定设置",
                           @"跳转到日期与时间设置", @"跳转到键盘设置", @"跳转到语言与地区设置",
                           @"跳转到设备管理设置", @"跳转到还原设置", @"跳转到墙纸设置",
                           @"跳转到声音设置", @"跳转到定位服务", @"跳转到iCloud储存空间",
                           @"跳转到 iTunes Store 和 App Store 设置", @"跳转到备忘录设置",
                           @"跳转到电话设置", @"跳转到FaceTime设置", @"跳转到音乐服务设置",
                           @"跳转到照片与相机服务设置", @"跳转到蜂窝网络设置"]);
}

- (void)openAppWithRow:(NSInteger)row {
    switch (row) {
        case 0: [SGSSystemUtil openSafariWithURL:[NSURL URLWithString:@"http://www.baidu.com"] options:nil completionHandler:nil]; break;
        case 1: [SGSSystemUtil openQQWithOptions:nil completionHandler:nil]; break;
        case 2: [SGSSystemUtil openWeChatWithOptions:nil completionHandler:nil]; break;
        case 3: [SGSSystemUtil openSinaWeiboWithOptions:nil completionHandler:nil]; break;
        case 4: [SGSSystemUtil openTencentWeiboWithOptions:nil completionHandler:nil]; break;
        case 5: [SGSSystemUtil openAlipayWithOptions:nil completionHandler:nil]; break;
        case 6: [SGSSystemUtil openTaobaoWithOptions:nil completionHandler:nil]; break;
        case 7: [SGSSystemUtil openTmallWithOptions:nil completionHandler:nil]; break;
        case 8: [SGSSystemUtil openJDWithOptions:nil completionHandler:nil]; break;
        case 9: [SGSSystemUtil openJDHDWithOptions:nil completionHandler:nil]; break;
        case 10: [SGSSystemUtil openMeiTuanWithOptions:nil completionHandler:nil]; break;
        case 11: [SGSSystemUtil openBaiduMapWithOptions:nil completionHandler:nil]; break;
        case 12: [SGSSystemUtil openAMapWithOptions:nil completionHandler:nil]; break;
        case 13: [SGSSystemUtil openSoSoMapWithOptions:nil completionHandler:nil]; break;
        default: break;
    }
}

- (void)openSysServiceWithRow:(NSInteger)row {
    switch (row) {
        case 0: [SGSSystemUtil callWithPhoneNumber:@"10086" completionHandler:nil]; break;
        case 1: [SGSSystemUtil sendSMSWithPhoneNumber:@"10086" completionHandler:nil]; break;
        case 2: [SGSSystemUtil sendEmailToAddress:@"kun.li@southgis.com" completionHandler:nil];
        case 3: [SGSSystemUtil gotoAppSettingWithCompletionHandler:nil]; break;
        case 4: [SGSSystemUtil gotoWiFiServices]; break;
        case 5: [SGSSystemUtil gotoBluetoothServices]; break;
        case 6: [SGSSystemUtil gotoNotificationsServices]; break;
        case 7: [SGSSystemUtil gotoGeneralServices]; break;
        case 8: [SGSSystemUtil gotoAboutServices]; break;
        case 9: [SGSSystemUtil gotoSoftwareUpdateServices]; break;
        case 10: [SGSSystemUtil gotoSiriServices]; break;
        case 11: [SGSSystemUtil gotoAccessibilityServices]; break;
        case 12: [SGSSystemUtil gotoAutoLockServices]; break;
        case 13: [SGSSystemUtil gotoDateAndTimeServices]; break;
        case 14: [SGSSystemUtil gotoKeyboardServices]; break;
        case 15: [SGSSystemUtil gotoInternationalServices]; break;
        case 16: [SGSSystemUtil gotoManagedConfigurationServices]; break;
        case 17: [SGSSystemUtil gotoResetServices]; break;
        case 18: [SGSSystemUtil gotoWallpaperServices]; break;
        case 19: [SGSSystemUtil gotoSoundsServices]; break;
        case 20: [SGSSystemUtil gotoLocationServices]; break;
        case 21: [SGSSystemUtil gotoStorageAndBackupServices]; break;
        case 22: [SGSSystemUtil gotoStorageServices]; break;
        case 23: [SGSSystemUtil gotoNotesServices]; break;
        case 24: [SGSSystemUtil gotoPhoneServices]; break;
        case 25: [SGSSystemUtil gotoFaceTimeServices]; break;
        case 26: [SGSSystemUtil gotoMusicServices]; break;
        case 27: [SGSSystemUtil gotoPhotosServices]; break;
        case 28: [SGSSystemUtil gotoCellularServices]; break;
        default: break;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return self.apps.count;
        case 1: return self.titles.count;
        default: return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sysCellId = @"SysCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sysCellId forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = self.apps[indexPath.row];
            break;
        case 1:
            cell.textLabel.text = self.titles[indexPath.row];
            break;
        default:
            break;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: return @"跳转应用";
        case 1: return @"跳转系统服务";
        default: return nil;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
            [self openAppWithRow:indexPath.row];
            break;
        case 1:
            [self openSysServiceWithRow:indexPath.row];
            break;
        default:
            break;
    }
}

@end
