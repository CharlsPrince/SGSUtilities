# Southgis iOS(OC) 移动支撑平台组件 - 常用工具组件

[![CI Status](http://img.shields.io/travis/Lee/SGSUtilities.svg?style=flat)](https://travis-ci.org/Lee/SGSUtilities)
[![Version](https://img.shields.io/cocoapods/v/SGSUtilities.svg?style=flat)](http://cocoapods.org/pods/SGSUtilities)
[![License](https://img.shields.io/cocoapods/l/SGSUtilities.svg?style=flat)](http://cocoapods.org/pods/SGSUtilities)
[![Platform](https://img.shields.io/cocoapods/p/SGSUtilities.svg?style=flat)](http://cocoapods.org/pods/SGSUtilities)

------

**SGSUtilities**（OC版本）是移动支撑平台 iOS Objective-C 组件之一，该组件集成了常用的工具类，提供快捷操作方法

## 安装
------
**SGSUtilities** 可以通过 **Cocoapods** 进行安装，可以复制下面的文字到 Podfile 中：

```ruby
target '项目名称' do
pod 'SGSUtilities', '~> 0.3.2'
end

仅加载 app 服务工具类
target '项目名称' do
pod 'SGSUtilities/AppUtil', '~> 0.3.2'
end

仅加载系统工具类
target '项目名称' do
pod 'SGSUtilities/SystemUtil', '~> 0.3.2'
end

仅加载设备工具类
target '项目名称' do
pod 'SGSUtilities/DeviceUtil', '~> 0.3.2'
end

仅加载网络图片加载缓存工具类
target '项目名称' do
pod 'SGSUtilities/ImageUtil', '~> 0.3.2'
end

仅加载网络工具类
target '项目名称' do
pod 'SGSUtilities/NetworkUtil', '~> 0.3.2'
end

仅加载倒计时工具以及倒计时按钮类
target '项目名称' do
pod 'SGSUtilities/CountdownUtil', '~> 0.3.2'
end

仅加载 UITableView 工具类
target '项目名称' do
pod 'SGSUtilities/TableViewUtil', '~> 0.3.2'
end

仅加载轮播图
target '项目名称' do
pod 'SGSUtilities/BannerView', '~> 0.3.2'
end

仅加载城市选择
target '项目名称' do
pod 'SGSUtilities/CityPicker', '~> 0.3.2'
end

仅加载Toast
target '项目名称' do
pod 'SGSUtilities/Toast', '~> 0.3.2'
end
```

## 功能
------
工具组件将常用而零散的功能集合到一起，提供了一些设备、系统、app相关的便捷方法，例如：跳转到系统服务、拨打电话、获取 UUID 、判断系统版本、获取 IP 地址、获取网络环境等

还可以使用 `SGSCountdownableButton` 快捷构造出具有倒计时的按钮，并且在程序进入后台时继续倒计时；还可以使用 `SGSBaseTableViewProtocol` 通过集约型的 block 和代理，将 `UITableView` 的业务逻辑集中起来

0.3.0版本开始，二维码功能已移至 [SGSScanner](http://112.94.224.243:8081/kun.li/sgsscanner/tree/master)

## 代码结构
------
> * SGSMacros：常用的宏定义和内联方法
> * SGSDeviceUtil：设备工具类，提供设备相关信息的快捷获取方法
> * SGSSystemUtil：系统工具类，提供系统服务相关的快捷操作方法
> * SGSAppUtil：应用工具类，提供App相关信息的快捷获取方法
> * SGSNetUtil：网络工具类，提供网络相关信息的快捷获取方法
> * SGSBaseTableViewProtocol：以代理对象的形式提供集约型block方式实现 `UITableView` 的业务
> * SGSCountdownManager：倒计时管理模块，适用于多个倒计时任务
> * SGSCountdownTask：倒计时任务类，适用于单个倒计时任务
> * SGSCountdownableButton：倒计时按钮
> * SGSImageCache：网络图片缓存
> * UIImageView+SGSImageLoad：加载网络图片和本地图片的扩展
> * SGSBannerView：图片轮播视图
> * SGSCityPickerController：城市选择视图
> * SGSToast：仿安卓Toast控件

## 使用方法
------

这里仅列出部分方法，详细请看头文件或接口文档

### SGSMacros

提供了常用宏定义和内联方法

```
@interface NetworkManager : NSObject
// 单例宏接口部分
SingletonInterface(NetworkManager)
@end

@implementation NetworkManager
// 单例宏实现部分
SingletonImplementation(NetworkManager)
@end

@implementation ViewController
- (void)viewDidLoad {
	NetworkManager *manager = [NetworkManager sharedNetworkManager];
	
	// 弱引用宏
	@weakify(self)
	[manager GET:@"http://www.example.com" params:nil completionHandler:^(NSData *result, NSError error) {
		// 强引用宏
		@strongify(self)
		
		if (error) {
			// 日志宏
			DLog(@"请求失败: %@", error);
		} 
		else if (isNilOrNULL(result)) { // 判断是否为空对象的内联函数
			DLog(@"返回对象为空");
		}
		else {
			// 内联函数，在主线程中异步执行block
			dispatch_async_on_main_queue(^{
				[self handleResult:result];
			});
		}
	}];
}

- (void)handleResult:(NSData *)data {
	NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
	CGFloat degree = []dict[@"degree"] floatValue];
	
	// 内联函数，角度转弧度
	CGFloat radians = degreesToRadians(degree);

	// 内联函数，判断当前是否在主队列中
	if (isMainQueue()) {
		[self.showView randerWithRadians:radians];
	}
}

- (NSArray *)dataSource {
 	// 懒加载宏 Lazy
	return Lazy(_dataSource, @[@"A", @"B", @"C"]);
}

- (NSArray *)countiesName {
	// 内联函数，国际标准国家名称 ISOCountryName
	return Lazy(_countiesName, ISOCountryName()); 
}

- (NSString *)docPath {
	return Lazy(_docPath, {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		if (paths.count == 0) {
			return nil; // 返回 nil
		}
		
		// 最后一个返回语句可以忽略 return 关键字
		// 返回 ~/Documents
		paths.firstObject; 
	}); 
}
@end

```

### SGSDeviceUtil


```
- (void)printDeviceInfo {
	NSLog(@"屏幕等级: %.0f", [SGSDeviceUtil screenScale]);
	NSLog(@"屏幕大小: %@", NSStringFromCGSize([SGSDeviceUtil screenSize]));
	NSLog(@"屏幕宽度: %.0f", [SGSDeviceUtil screenWidth]);
	NSLog(@"屏幕高度: %.0f", [SGSDeviceUtil screenHeight]);
	NSLog(@"屏幕分辨率: %@", NSStringFromCGSize([SGSDeviceUtil sizeInPixel]));
	NSLog(@"屏幕像素: %.0f", [SGSDeviceUtil pixelsPerInch]);
	NSLog(@"当前屏幕范围 %@", NSStringFromCGRect([SGSDeviceUtil currentScreenBounds]));
	NSLog(@"竖屏? %@, 横屏? %@", [SGSDeviceUtil isPortrait] ? @"YES" : @"NO", [SGSDeviceUtil isLandscape] ? @"YES" : @"NO");
	
	NSLog(@"UUID %@", [SGSDeviceUtil UUID]);
	NSLog(@"设备名称 %@", [SGSDeviceUtil deviceName]);
	NSLog(@"系统名称 %@", [SGSDeviceUtil systemName]);
	NSLog(@"设备型号 %@", [SGSDeviceUtil machineModel]);
	NSLog(@"设备型号名称 %@", [SGSDeviceUtil machineModelName]);
	NSLog(@"系统版本 %@", [SGSDeviceUtil systemVersion]);
	NSLog(@"系统版本是否为 iOS 9.0 以上? %@", [SGSDeviceUtil iOS9OrLater] ? @"YES" : @"NO");
	
	NSLog(@"当前系统设置的国家: %@", [SGSDeviceUtil localeCountry]);
	NSLog(@"国家区号: %@", [SGSDeviceUtil localeCountryCode]);
	NSLog(@"当前设备的首选语言: %@", [SGSDeviceUtil preferredLanguage]);
	NSLog(@"首选语言代码: %@", [SGSDeviceUtil preferredLanguageCode]);
	NSLog(@"运营商名: %@", [SGSDeviceUtil carrierName]);
	
	NSLog(@"磁盘总大小: %@", [NSByteCountFormatter stringFromByteCount:[SGSDeviceUtil diskSpaceTotal] countStyle:NSByteCountFormatterCountStyleBinary];
	NSLog(@"磁盘剩余空间: %@", [NSByteCountFormatter stringFromByteCount:[SGSDeviceUtil diskSpaceFree] countStyle:NSByteCountFormatterCountStyleBinary]);
	NSLog(@"磁盘已使用空间: %@", [NSByteCountFormatter stringFromByteCount:[SGSDeviceUtil diskSpaceUsed] countStyle:NSByteCountFormatterCountStyleBinary]);
	
	NSLog(@"物理内存总大小: %@", [NSByteCountFormatter stringFromByteCount:[SGSDeviceUtil memoryTotal] countStyle:NSByteCountFormatterCountStyleBinary]);
	NSLog(@"剩余内存大小: %@", [NSByteCountFormatter stringFromByteCount:[SGSDeviceUtil memoryFree] countStyle:NSByteCountFormatterCountStyleBinary]);
	NSLog(@"已使用内存: %@", [NSByteCountFormatter stringFromByteCount:[SGSDeviceUtil memoryUsed] countStyle:NSByteCountFormatterCountStyleBinary]);
	
	NSLog(@"CPU总核数: %lu", [SGSDeviceUtil processorCount]);
	NSLog(@"CPU当前可用核数: %lu", [SGSDeviceUtil activeProcessorCount]);
	NSLog(@"当前进程名: %@", [SGSDeviceUtil processName]);
	NSLog(@"CPU 使用状况: %.2f", [SGSDeviceUtil cpuUsage] * 100);
}
```

### SGSSystemUtil

```
- (void)goto {
	// 切换应用
	[SGSSystemUtil openURL:@"mqq://" options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @YES} completionHandler:nil];
	
	// 打开QQ
	[SGSSystemUtil openQQWithOptions:nil completionHandler:nil];
	
	// 打电话
	[SGSSystemUtil callWithPhoneNumber:@"xxx" completionHandler:nil];
	
	// 发短信
	[SGSSystemUtil sendSMSWithPhoneNumber:@"xxx" completionHandler:nil];
}
```

### SGSAppUtil

```
- (void)printAppInfo {
	NSLog(@"Documents 文件夹路径: %@", [SGSAppUtil documentsPath]);
	NSLog(@"Caches 文件夹路径: %@", [SGSAppUtil cachesPath]);
	NSLog(@"Library 文件夹路径: %@", [SGSAppUtil libraryPath]);
	
	NSLog(@"App 名: %@", [SGSAppUtil appName]);
	NSLog(@"appBundleID: %@", [SGSAppUtil appBundleID]);
	NSLog(@"App 版本: %@", [SGSAppUtil appVersion]);
	NSLog(@"App 构建版本: %@", [SGSAppUtil appBuildVersion]);
	NSLog(@"应用图标角标数值: %@", [SGSAppUtil appIconBadgeNumber]);
	
	// 设置应用图标角标数值
	[SGSAppUtil setAppIconBadgeNumber:10];
	
	// 清空应用图标角标数值
	[SGSAppUtil clearAppIconBadgeNumber];
}
```

### SGSNetUtil

网络工具类提供了网络状态判断、监听，以及获取 IP 地址等便捷方法

网络工具类可以根据跟定的主机名或者 IP 地址初始化，也可以直接使用 `+networkReachabilityForInternetConnection` 初始化用于判断全域的网络状态

单例 `+sharedInstance` 将采用 `+networkReachabilityForInternetConnection` 进行初始化

#### 网络状态

默认提供的网络状态共有6种
> 1. SGSNetworkStatusUnknown：未知网络
> 2. SGSNetworkStatusNotReachable：无网络状态
> 3. SGSNetworkStatusReachableViaWiFi：Wi-Fi 网络环境
> 4. SGSNetworkStatusReachableViaWWAN2G：2G 蜂窝网络
> 5. SGSNetworkStatusReachableViaWWAN3G：3G 蜂窝网络
> 6. SGSNetworkStatusReachableViaWWAN4G：4G 蜂窝网络

#### 监听网络状态变化

使用 `startMonitoring` 开启网络监听，使用 `stopMonitoring` 停止监听

```
- (void)viewDidLoad {
    [super viewDidLoad];
        
    // 开始监听网络状态
    [[SGSNetUtil sharedInstance] startMonitoring];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusDidChange:) name:SGSNetReachabilityDidChangedNotification object:nil];
}

- (void)networkStatusDidChange:(NSNotification *)sender {
	SGSNetworkStatus status = [sender.userInfo[SGSNetReachabilityNotificationStatusItem] integerValue];
	
	// 处理网络状态变化事件...
}
```

#### 静态网络连通状态获取

使用静态网络状态可以直接获取当前网络环境，而不需要开启网络监听，适用于简单的网络状态判断

```
- (void)staticNetworkReachability {
	NSLog(@"是否连接到网络? %@", [SGSNetUtil isReachable] ? @"YES" : @"NO");
	NSLog(@"当前网络环境是 WiFi? %@", [SGSNetUtil isReachableViaWiFi] ? @"YES" : @"NO");
	NSLog(@"当前网络环境是蜂窝网络? %@", [SGSNetUtil isReachableViaWWAN] ? @"YES" : @"NO");
	NSLog(@"当前网络环境是2G网络? %@", [SGSNetUtil isReachableViaWWAN2G] ? @"YES" : @"NO");
	NSLog(@"当前网络环境是3G网络? %@", [SGSNetUtil isReachableViaWWAN3G] ? @"YES" : @"NO");
	NSLog(@"当前网络环境是4G网络? %@", [SGSNetUtil isReachableViaWWAN4G] ? @"YES" : @"NO");
}
```

#### 动态网络连通状态获取

通过 `SGSNetUtil` 实例的属性可以动态获取网络状态，但是要先开启网络监听，开启网络监听后获取网络状态的效率比静态网络状态获取略高一些

当网络监听停止之后， `SGSNetUtil` 实例的网络状态属性不再更新

```
- (void)dynamicNetworkReachability {
	SGSNetUtil *netObserver = [SGSNetUtil sharedInstance];
	[netObserver startMonitoring];
	
	NSLog(@"是否连接到网络? %@", netObserver.isReachable ? @"YES" : @"NO");
	NSLog(@"当前网络环境是 WiFi? %@", netObserver.isReachableViaWiFi ? @"YES" : @"NO");
	NSLog(@"当前网络环境是蜂窝网络? %@", netObserver.isReachableViaWWAN ? @"YES" : @"NO");
	NSLog(@"当前网络环境是2G网络? %@", netObserver.isReachableViaWWAN2G ? @"YES" : @"NO");
	NSLog(@"当前网络环境是3G网络? %@", netObserver.isReachableViaWWAN3G ? @"YES" : @"NO");
	NSLog(@"当前网络环境是4G网络? %@", netObserver.isReachableViaWWAN4G ? @"YES" : @"NO");
}
```

#### 获取 IP 地址

使用 `+ipAddressForWiFi` 获取 WiFi IP 地址

使用 `+ipAddressForWiFi` 获取蜂窝网络的 IP 地址

`+ipAddress` 方法优先获取 WiFi IP 地址，如果没有在 WiFi 环境下那么尝试获取蜂窝网络的 IP 地址，如果当前网络状态为 Unknown 或者没有连接到网络，那么将返回 `nil`

```
- (void)phoneIPAddress {
	NSLog(@"IP 地址: %@", [SGSNetUtil ipAddress]);
	NSLog(@"WiFi IP 地址: %@", [SGSNetUtil ipAddressForWiFi]);
	NSLog(@"蜂窝网络 IP 地址: %@", [SGSNetUtil ipAddressForWWAN]);
}
```


### 城市选择视图

参照 `UIImagePickerController` 封装的一个城市选择视图，包括定位当前城市、记录选择历史、热门城市。城市列表中的城市仅到直辖市和地级市一级。

```
- (void)showCityPickerController {
    SGSCityPickerController *cityPicker = [SGSCityPickerController cityPickerController];
    cityPicker.hotCities = @[@"北京", @"上海", @"广州", @"深圳", @"武汉", @"杭州", @"南京", @"厦门"]; // 设置热门城市，如果为空默认为"北上广深"
    cityPicker.sectionIndexColor = [UIColor redColor];  // 设置右侧索引的文字颜色，如果为空则使用默认的系统蓝色
    cityPicker.pickerDelegate = self;  // 设置代理
    [self presentViewController:cityPicker animated:YES completion:nil];
}


#pragma mark - SGSCityPickerControllerDelegate

- (void)sgsCityPickerController:(SGSCityPickerController *)picker didFinishPickingCity:(NSString *)cityName {
    NSLog(@"当前选择城市：%@", cityName);
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)sgsCityPickerControllerDidCancel:(SGSCityPickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
```


## 结尾
------
**移动支撑平台** 是研发中心移动团队打造的一套移动端开发便捷技术框架。这套框架立旨于满足公司各部门不同的移动业务研发需求，实现App快速定制的研发目标，降低研发成本，缩短开发周期，达到代码的易扩展、易维护、可复用的目的，从而让开发人员更专注于产品或项目的优化与功能扩展

整体框架采用组件化方式封装，以面向服务的架构形式供开发人员使用。同时兼容 Android 和 iOS 两大移动平台，涵盖 **网络通信**, **数据持久化存储**, **数据安全**, **移动ArcGIS** 等功能模块（近期推出混合开发组件，只需采用前端的开发模式即可同时在 Android 和 iOS 两个平台运行），各模块间相互独立，开发人员可根据项目需求使用相应的组件模块

更多组件请参考：
> * [数据持久化存储组件](http://112.94.224.243:8081/kun.li/sgsdatabase/tree/master)
> * [数据安全组件](http://112.94.224.243:8081/kun.li/sgscrypto/tree/master)
> * [HTTP 请求模块组件](http://112.94.224.243:8081/kun.li/sgshttpmodule/tree/master)
> * [ArcGIS绘图组件](https://github.com/crash-wu/SGSketchLayer-OC)
> * [常用类别组件](http://112.94.224.243:8081/kun.li/sgscategories/tree/master)
> * [集合页面视图](http://112.94.224.243:8081/kun.li/sgscollectionpageview/tree/master)
> * [二维码扫描与生成](http://112.94.224.243:8081/kun.li/sgsscanner/tree/master)

如果您对移动支撑平台有更多的意见和建议，欢迎联系我们！

研发中心移动团队

2016 年 09月 12日  

## Author
------
Lee, kun.li@southgis.com

## License
------
SGSUtilities is available under the MIT license. See the LICENSE file for more info.
