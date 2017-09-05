//
//  CityViewController.m
//  SGSUtilities
//
//  Created by Lee on 2017/2/6.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "CityViewController.h"
#import "SGSCityPickerController.h"


@interface CityViewController () <SGSCityPickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *currentCity = [SGSCityEngine currentCity];
    if (currentCity != nil) {
        // 获取之前选择的城市
        _cityLabel.text = [NSString stringWithFormat:@"当前选择城市：%@", currentCity];
    }

    NSLog(@"历史记录：%@", [SGSCityEngine visitedHistory]);
}

- (IBAction)selectCity:(UIButton *)sender {
    SGSCityPickerController *cityPicker = [SGSCityPickerController cityPickerController];
    cityPicker.hotCities = [self defaultHotCity];
    cityPicker.sectionIndexColor = [UIColor redColor];
    cityPicker.pickerDelegate = self;
    [self presentViewController:cityPicker animated:YES completion:nil];
}

- (NSArray *)defaultHotCity {
    return @[@"北京", @"上海", @"广州", @"深圳", @"天津", @"武汉",
             @"杭州", @"南京", @"长沙", @"厦门", @"成都", @"重庆"];
}

#pragma mark - SGSCityPickerControllerDelegate

- (void)sgsCityPickerController:(SGSCityPickerController *)picker didFinishPickingCity:(NSString *)cityName {
    _cityLabel.text = [NSString stringWithFormat:@"当前选择城市：%@", cityName];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)sgsCityPickerControllerDidCancel:(SGSCityPickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
