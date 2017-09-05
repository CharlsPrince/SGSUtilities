/*!
 *  @file CityPickerController.h
 *
 *  @abstract 城市选择列表视图
 *
 *  @author Created by Lee on 16/10/21.
 *
 *  @copyright 2016年 SouthGIS. All rights reserved.
 */

#import <UIKit/UIKit.h>

/*!
 *  iOS 10 以后，需要在 info.plist 中加入 `Privacy - Location When In Use Usage Description`
 */


NS_ASSUME_NONNULL_BEGIN

@protocol SGSCityPickerControllerDelegate;

/*!
 *  城市数据源
 */
@interface SGSCityEngine : NSObject

/*! 城市列表 */
+ (NSArray<NSString *> *)cityList;

/*! 历史记录 */
+ (nullable NSArray<NSString *> *)visitedHistory;

/*! 当前选择城市 */
+ (nullable NSString *)currentCity;

/*! 清除历史记录 */
+ (void)clearVisitedHistory;

/*! 清除当前选择城市 */
+ (void)clearCurrentCity;

@end



/*!
 *  选择城市，封装形式参照 `UIImagePickerController`
 */
@interface SGSCityPickerController : UINavigationController

/*! 热门城市列表, 在界面显示前如果为空，那么默认的热门城市为：北京、上海、广州、深圳 */
@property (nullable, nonatomic, strong) NSArray<NSString *> *hotCities;

/*! 右侧索引文字颜色 */
@property (nullable, nonatomic, strong) UIColor *sectionIndexColor;

/*! 取消按钮标题, 如果标题和图标都为空，默认为 "取消" 文字 */
@property (nullable, nonatomic, copy) NSString *cancelItemTitle;

/*! 取消按钮图标 */
@property (nullable, nonatomic, strong) UIImage *cancelItemIcon;

/*! 城市选择控制器代理 */
@property (nullable, nonatomic, weak) id<UINavigationControllerDelegate, SGSCityPickerControllerDelegate> pickerDelegate;

/*! 工厂方法 */
+ (SGSCityPickerController *)cityPickerController;

@end




/*!
 *  城市选择控制器代理
 */
@protocol SGSCityPickerControllerDelegate <NSObject>
@optional
/*! 选择城市后回调 */
- (void)sgsCityPickerController:(SGSCityPickerController *)picker didFinishPickingCity:(NSString *)cityName;

/*! 取消回调 */
- (void)sgsCityPickerControllerDidCancel:(SGSCityPickerController *)picker;
@end

NS_ASSUME_NONNULL_END
