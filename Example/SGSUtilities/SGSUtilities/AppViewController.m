/*!
 @header AppViewController.m
  
 @author Created by Lee on 16/9/12.
 
 @copyright 2016年 SouthGIS. All rights reserved.
 
 */

#import "AppViewController.h"
#import <SGSUtilities/SGSAppUtil.h>

@interface AppViewController ()
@property (weak, nonatomic) IBOutlet UITableViewCell *appName;
@property (weak, nonatomic) IBOutlet UITableViewCell *appVersion;
@property (weak, nonatomic) IBOutlet UITableViewCell *appBuildVersion;
@property (weak, nonatomic) IBOutlet UITableViewCell *bundleId;
@property (weak, nonatomic) IBOutlet UITableViewCell *appIconBadgeNumber;
@property (weak, nonatomic) IBOutlet UITableViewCell *setBadgeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *documentsPath;
@property (weak, nonatomic) IBOutlet UITableViewCell *cachesPath;
@property (weak, nonatomic) IBOutlet UITableViewCell *libPath;
@property (weak, nonatomic) IBOutlet UITableViewCell *infoPlist;

@end

@implementation AppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _appName.textLabel.text = [SGSAppUtil appName];
    _appVersion.textLabel.text = [SGSAppUtil appVersion];
    _appBuildVersion.textLabel.text = [SGSAppUtil appBuildVersion];
    _bundleId.textLabel.text = [SGSAppUtil appBundleID];
    _appIconBadgeNumber.detailTextLabel.text = @([SGSAppUtil appIconBadgeNumber]).description;
    _documentsPath.detailTextLabel.text = [SGSAppUtil documentsPath];
    _cachesPath.detailTextLabel.text = [SGSAppUtil cachesPath];
    _libPath.detailTextLabel.text = [SGSAppUtil libraryPath];
    _infoPlist.textLabel.text = [SGSAppUtil mainBundleInfo].description;
}

- (IBAction)setBadgeNumber:(UIButton *)sender {
    UITextField *field = nil;
    
    for (UIView *view in _setBadgeCell.contentView.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            field = (UITextField *)view;
        }
    }
    
    if (field == nil) {
        return;
    }
    
    NSString *text = field.text;
    if (text.length == 0) {
        [self showAlert];
        return;
    }
    
    NSInteger number = text.integerValue;
    [SGSAppUtil setAppIconBadgeNumber:number];
    _appIconBadgeNumber.detailTextLabel.text = @([SGSAppUtil appIconBadgeNumber]).description;
    
    field.text = nil;
    [field resignFirstResponder];
}

- (IBAction)clearBadgeNumber:(UIButton *)sender {
    [SGSAppUtil clearAppIconBadgeNumber];
    _appIconBadgeNumber.detailTextLabel.text = @([SGSAppUtil appIconBadgeNumber]).description;
}

- (void)showAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"不能为空" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
