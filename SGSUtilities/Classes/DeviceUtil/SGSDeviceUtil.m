/*!
 *  @file SGSDeviceUtil.m
 *
 *  @author Created by Lee on 16/9/2.
 *
 *  @copyright 2016年 SouthGIS. All rights reserved.
 */

#import "SGSDeviceUtil.h"
#include <sys/sysctl.h>
#include <mach/mach.h>
@import CoreTelephony;
@import UIKit;

@implementation SGSDeviceUtil

+ (CGFloat)screenScale {
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [UIScreen mainScreen].scale;
    });
    
    return scale;
}

+ (CGSize)screenSize {
    static CGSize size;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size = [UIScreen mainScreen].bounds.size;
        if (size.height < size.width) {
            CGFloat temp = size.height;
            size.height = size.width;
            size.width = temp;
        }
    });
    
    return size;
}

+ (CGFloat)screenWidth {
    return [self screenSize].width;
}

+ (CGFloat)screenHeight {
    return [self screenSize].height;
}

+ (CGSize)sizeInPixel {
    CGSize size = CGSizeZero;
    
    NSString *model = [self machineModel];

    if ([model hasPrefix:@"iPhone"]) {
        if ([model isEqualToString:@"iPhone7,1"]) return CGSizeMake(1080, 1920);
        if ([model isEqualToString:@"iPhone8,2"]) return CGSizeMake(1080, 1920);
        if ([model isEqualToString:@"iPhone9,2"]) return CGSizeMake(1080, 1920);
        if ([model isEqualToString:@"iPhone9,4"]) return CGSizeMake(1080, 1920);
    }
    if ([model hasPrefix:@"iPad"]) {
        if ([model hasPrefix:@"iPad6,7"]) size = CGSizeMake(2048, 2732);
        if ([model hasPrefix:@"iPad6,8"]) size = CGSizeMake(2048, 2732);
    }
    
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        UIScreen *screen = [UIScreen mainScreen];
        CGRect nativeBounds = screen.nativeBounds;
        
        if (!CGRectIsEmpty(nativeBounds)) {
            size = nativeBounds.size;
        } else {
            CGFloat scale = screen.scale;
            size = screen.bounds.size;
            size.width *= scale;
            size.height *= scale;
        }
        if (size.height < size.width) {
            CGFloat temp = size.height;
            size.height = size.width;
            size.width = temp;
        }
    }
    return size;
}

+ (CGFloat)pixelsPerInch {
    static CGFloat ppi = 0;
    static dispatch_once_t one;
    static NSString *name;
    dispatch_once(&one, ^{
        NSDictionary<NSString*, NSNumber *> *dic = @{
            @"Watch1,1" : @326, //@"Apple Watch 38mm",
            @"Watch1,2" : @326, //@"Apple Watch 43mm",
            @"Watch2,3" : @326, //@"Apple Watch Series 2 38mm",
            @"Watch2,4" : @326, //@"Apple Watch Series 2 42mm",
            @"Watch2,6" : @326, //@"Apple Watch Series 1 38mm",
            @"Watch1,7" : @326, //@"Apple Watch Series 1 42mm",
                                                     
            @"iPod1,1" : @163, //@"iPod touch 1",
            @"iPod2,1" : @163, //@"iPod touch 2",
            @"iPod3,1" : @163, //@"iPod touch 3",
            @"iPod4,1" : @326, //@"iPod touch 4",
            @"iPod5,1" : @326, //@"iPod touch 5",
            @"iPod7,1" : @326, //@"iPod touch 6",
                                                     
            @"iPhone1,1" : @163, //@"iPhone 1G",
            @"iPhone1,2" : @163, //@"iPhone 3G",
            @"iPhone2,1" : @163, //@"iPhone 3GS",
            @"iPhone3,1" : @326, //@"iPhone 4 (GSM)",
            @"iPhone3,2" : @326, //@"iPhone 4",
            @"iPhone3,3" : @326, //@"iPhone 4 (CDMA)",
            @"iPhone4,1" : @326, //@"iPhone 4S",
            @"iPhone5,1" : @326, //@"iPhone 5",
            @"iPhone5,2" : @326, //@"iPhone 5",
            @"iPhone5,3" : @326, //@"iPhone 5c",
            @"iPhone5,4" : @326, //@"iPhone 5c",
            @"iPhone6,1" : @326, //@"iPhone 5s",
            @"iPhone6,2" : @326, //@"iPhone 5s",
            @"iPhone7,1" : @401, //@"iPhone 6 Plus",
            @"iPhone7,2" : @326, //@"iPhone 6",
            @"iPhone8,1" : @326, //@"iPhone 6s",
            @"iPhone8,2" : @401, //@"iPhone 6s Plus",
            @"iPhone8,4" : @326, //@"iPhone SE",
            @"iPhone9,1" : @326, //@"iPhone 7",
            @"iPhone9,2" : @401, //@"iPhone 7 Plus",
            @"iPhone9,3" : @326, //@"iPhone 7",
            @"iPhone9,4" : @401, //@"iPhone 7 Plus",
                                                     
            @"iPad1,1" : @132, //@"iPad 1",
            @"iPad2,1" : @132, //@"iPad 2 (WiFi)",
            @"iPad2,2" : @132, //@"iPad 2 (GSM)",
            @"iPad2,3" : @132, //@"iPad 2 (CDMA)",
            @"iPad2,4" : @132, //@"iPad 2",
            @"iPad2,5" : @264, //@"iPad mini 1",
            @"iPad2,6" : @264, //@"iPad mini 1",
            @"iPad2,7" : @264, //@"iPad mini 1",
            @"iPad3,1" : @324, //@"iPad 3 (WiFi)",
            @"iPad3,2" : @324, //@"iPad 3 (4G)",
            @"iPad3,3" : @324, //@"iPad 3 (4G)",
            @"iPad3,4" : @324, //@"iPad 4",
            @"iPad3,5" : @324, //@"iPad 4",
            @"iPad3,6" : @324, //@"iPad 4",
            @"iPad4,1" : @324, //@"iPad Air",
            @"iPad4,2" : @324, //@"iPad Air",
            @"iPad4,3" : @324, //@"iPad Air",
            @"iPad4,4" : @264, //@"iPad mini 2",
            @"iPad4,5" : @264, //@"iPad mini 2",
            @"iPad4,6" : @264, //@"iPad mini 2",
            @"iPad4,7" : @264, //@"iPad mini 3",
            @"iPad4,8" : @264, //@"iPad mini 3",
            @"iPad4,9" : @264, //@"iPad mini 3",
            @"iPad5,1" : @264, //@"iPad mini 4",
            @"iPad5,2" : @264, //@"iPad mini 4",
            @"iPad5,3" : @324, //@"iPad Air 2",
            @"iPad5,4" : @324, //@"iPad Air 2",
            @"iPad6,3" : @324, //@"iPad Pro (9.7 inch)",
            @"iPad6,4" : @324, //@"iPad Pro (9.7 inch)",
            @"iPad6,7" : @264, //@"iPad Pro (12.9 inch)",
            @"iPad6,8" : @264, //@"iPad Pro (12.9 inch)",
        };
        NSString *model = [self machineModel];
        if (model) {
            ppi = dic[name].doubleValue;
        }
        if (ppi == 0) ppi = 326;
    });
    return ppi;
}

+ (CGRect)currentScreenBounds {
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    if ([self isLandscape]) {
        CGFloat temp = bounds.size.width;
        bounds.size.width = bounds.size.height;
        bounds.size.height = temp;
    }
    
    return bounds;
}

+ (BOOL)isPortrait {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    return UIInterfaceOrientationIsPortrait(orientation);
}

+ (BOOL)isLandscape {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    return UIInterfaceOrientationIsLandscape(orientation);
}

+ (NSString *)UUID {
    static NSString *result;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef uuidStr = CFUUIDCreateString(kCFAllocatorDefault, uuid);
        result = CFBridgingRelease(CFStringCreateCopy(kCFAllocatorDefault, uuidStr));
        CFRelease(uuid);
        CFRelease(uuidStr);
    });
    
    return result;
}

+ (NSString *)deviceName {
    return [UIDevice currentDevice].name;
}

+ (NSString *)systemName {
    static NSString *name;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        name = [UIDevice currentDevice].systemName;
    });
    
    return name;
}

+ (NSString *)machineModel {
    static NSString *model;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        model = [NSString stringWithUTF8String:machine];
        free(machine);
    });
    
    return model;
}

+ (NSString *)machineModelName {
    static NSString *name;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *model = [self machineModel];
        if (!model) return;
        NSDictionary *dic = @{
                              @"Watch1,1" : @"Apple Watch 38mm",
                              @"Watch1,2" : @"Apple Watch 42mm",
                              @"Watch2,3" : @"Apple Watch Series 2 38mm",
                              @"Watch2,4" : @"Apple Watch Series 2 42mm",
                              @"Watch2,6" : @"Apple Watch Series 1 38mm",
                              @"Watch1,7" : @"Apple Watch Series 1 42mm",
                              
                              @"iPod1,1" : @"iPod touch 1",
                              @"iPod2,1" : @"iPod touch 2",
                              @"iPod3,1" : @"iPod touch 3",
                              @"iPod4,1" : @"iPod touch 4",
                              @"iPod5,1" : @"iPod touch 5",
                              @"iPod7,1" : @"iPod touch 6",
                              
                              @"iPhone1,1" : @"iPhone 1G",
                              @"iPhone1,2" : @"iPhone 3G",
                              @"iPhone2,1" : @"iPhone 3GS",
                              @"iPhone3,1" : @"iPhone 4 (GSM)",
                              @"iPhone3,2" : @"iPhone 4",
                              @"iPhone3,3" : @"iPhone 4 (CDMA)",
                              @"iPhone4,1" : @"iPhone 4S",
                              @"iPhone5,1" : @"iPhone 5",
                              @"iPhone5,2" : @"iPhone 5",
                              @"iPhone5,3" : @"iPhone 5c",
                              @"iPhone5,4" : @"iPhone 5c",
                              @"iPhone6,1" : @"iPhone 5s",
                              @"iPhone6,2" : @"iPhone 5s",
                              @"iPhone7,1" : @"iPhone 6 Plus",
                              @"iPhone7,2" : @"iPhone 6",
                              @"iPhone8,1" : @"iPhone 6s",
                              @"iPhone8,2" : @"iPhone 6s Plus",
                              @"iPhone8,4" : @"iPhone SE",
                              @"iPhone9,1" : @"iPhone 7",
                              @"iPhone9,2" : @"iPhone 7 Plus",
                              @"iPhone9,3" : @"iPhone 7",
                              @"iPhone9,4" : @"iPhone 7 Plus",
                              
                              @"iPad1,1" : @"iPad 1",
                              @"iPad2,1" : @"iPad 2 (WiFi)",
                              @"iPad2,2" : @"iPad 2 (GSM)",
                              @"iPad2,3" : @"iPad 2 (CDMA)",
                              @"iPad2,4" : @"iPad 2",
                              @"iPad2,5" : @"iPad mini 1",
                              @"iPad2,6" : @"iPad mini 1",
                              @"iPad2,7" : @"iPad mini 1",
                              @"iPad3,1" : @"iPad 3 (WiFi)",
                              @"iPad3,2" : @"iPad 3 (4G)",
                              @"iPad3,3" : @"iPad 3 (4G)",
                              @"iPad3,4" : @"iPad 4",
                              @"iPad3,5" : @"iPad 4",
                              @"iPad3,6" : @"iPad 4",
                              @"iPad4,1" : @"iPad Air",
                              @"iPad4,2" : @"iPad Air",
                              @"iPad4,3" : @"iPad Air",
                              @"iPad4,4" : @"iPad mini 2",
                              @"iPad4,5" : @"iPad mini 2",
                              @"iPad4,6" : @"iPad mini 2",
                              @"iPad4,7" : @"iPad mini 3",
                              @"iPad4,8" : @"iPad mini 3",
                              @"iPad4,9" : @"iPad mini 3",
                              @"iPad5,1" : @"iPad mini 4",
                              @"iPad5,2" : @"iPad mini 4",
                              @"iPad5,3" : @"iPad Air 2",
                              @"iPad5,4" : @"iPad Air 2",
                              @"iPad6,3" : @"iPad Pro (9.7 inch)",
                              @"iPad6,4" : @"iPad Pro (9.7 inch)",
                              @"iPad6,7" : @"iPad Pro (12.9 inch)",
                              @"iPad6,8" : @"iPad Pro (12.9 inch)",
                              
                              @"AppleTV2,1" : @"Apple TV 2",
                              @"AppleTV3,1" : @"Apple TV 3",
                              @"AppleTV3,2" : @"Apple TV 3",
                              @"AppleTV5,3" : @"Apple TV 4",
                              
                              @"i386" : @"Simulator x86",
                              @"x86_64" : @"Simulator x64",
                              };
        name = dic[model];
        if (!name) name = model;
    });
    
    return name;
}

+ (NSString *)systemVersion {
    static NSString *version;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [UIDevice currentDevice].systemVersion;
    });
    
    return version;
}

+ (float)systemVersionNumber {
    static float version;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [UIDevice currentDevice].systemVersion.floatValue;
    });
    
    return version;
}

+ (BOOL)iOS7OrLater {
    return [self systemVersionGreaterThanOrEqualTo:@"7"];
}

+ (BOOL)iOS8OrLater {
    return [self systemVersionGreaterThanOrEqualTo:@"8"];
}

+ (BOOL)iOS9OrLater {
    return [self systemVersionGreaterThanOrEqualTo:@"9"];
}

+ (BOOL)iOS10OrLater {
    return [self systemVersionGreaterThanOrEqualTo:@"10"];
}

+ (BOOL)systemVersionEqualTo:(float)version {
    return (fabs([self systemVersionNumber] - version) < 1e-6);
}

+ (BOOL)systemVersionGreaterThan:(NSString *)version {
    return ([[self systemVersion] compare:version options:NSNumericSearch] == NSOrderedDescending);
}

+ (BOOL)systemVersionGreaterThanOrEqualTo:(NSString *)version {
    return ([[self systemVersion] compare:version options:NSNumericSearch] >= NSOrderedSame);
}

+ (BOOL)systemVersionLessThan:(NSString *)version {
    return ([[self systemVersion] compare:version options:NSNumericSearch] == NSOrderedAscending);
}

+ (BOOL)systemVersionLessThanOrEqualTo:(NSString *)version {
//    return ([self systemVersionNumber] <= version);
    return ([[self systemVersion] compare:version options:NSNumericSearch] <= NSOrderedSame);
}

+ (NSString *)localeCountry {
    return [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:[self localeCountryCode]];
}

+ (NSString *)localeCountryCode {
    return [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
}

+ (NSArray<NSString *> *)deviceLanguageCodes {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
}

+ (NSString *)preferredLanguageCode {
    return [self deviceLanguageCodes].firstObject;
}

+ (NSString *)preferredLanguage {
    return [[NSLocale currentLocale] displayNameForKey:NSLocaleLanguageCode value:[self preferredLanguageCode]];
}

+ (NSString *)carrierName {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    return carrier.carrierName;
}

+ (int64_t)diskSpaceTotal {
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:NULL];
    if (attrs == nil) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemSize] longLongValue];
    
    return (space < 0) ? -1 : space;
}

+ (int64_t)diskSpaceFree {
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:NULL];
    if (attrs == nil) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
    
    return (space < 0) ? -1 : space;
}

+ (int64_t)diskSpaceUsed {
    int64_t total = self.diskSpaceTotal;
    int64_t free = self.diskSpaceFree;
    if (total < 0 || free < 0) return -1;
    int64_t used = total - free;
    
    return (used < 0) ? -1 : used;
}

+ (int64_t)memoryTotal {
    int64_t total = [[NSProcessInfo processInfo] physicalMemory];
    return (total < 0) ? -1 : total;
}

+ (int64_t)memoryFree {
    vm_statistics_data_t vm_stat;
    bzero(&vm_stat, sizeof(vm_stat));
    mach_msg_type_number_t host_size = HOST_VM_INFO_COUNT;

    kern_return_t kern = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    
    return (kern == KERN_SUCCESS) ? (vm_stat.free_count * vm_page_size) : -1;
}

+ (int64_t)memoryUsed {
    vm_statistics_data_t vm_stat;
    bzero(&vm_stat, sizeof(vm_stat));
    mach_msg_type_number_t host_size = HOST_VM_INFO_COUNT;
    
    kern_return_t kern = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    
    return vm_page_size * (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count);
}

+ (int64_t)memoryActive {
    vm_statistics_data_t vm_stat;
    bzero(&vm_stat, sizeof(vm_stat));
    mach_msg_type_number_t host_size = HOST_VM_INFO_COUNT;
    
    kern_return_t kern = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    
    return (kern == KERN_SUCCESS) ? (vm_stat.active_count * vm_page_size) : -1;
}

+ (int64_t)memoryInactive {
    vm_statistics_data_t vm_stat;
    bzero(&vm_stat, sizeof(vm_stat));
    mach_msg_type_number_t host_size = HOST_VM_INFO_COUNT;
    
    kern_return_t kern = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    
    return (kern == KERN_SUCCESS) ? (vm_stat.inactive_count * vm_page_size) : -1;
}

+ (int64_t)memoryWired {
    vm_statistics_data_t vm_stat;
    bzero(&vm_stat, sizeof(vm_stat));
    mach_msg_type_number_t host_size = HOST_VM_INFO_COUNT;
    
    kern_return_t kern = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    
    return (kern == KERN_SUCCESS) ? (vm_stat.wire_count * vm_page_size) : -1;
}


+ (NSUInteger)processorCount {
    return [[NSProcessInfo processInfo] processorCount];
}

+ (NSUInteger)activeProcessorCount {
    return [[NSProcessInfo processInfo] activeProcessorCount];
}

+ (NSString *)processName {
    return [[NSProcessInfo processInfo] processName];
}

+ (NSArray *)cpuUsagePerProcessor {
    processor_info_array_t cpuInfo, prevCPUInfo = nil;
    mach_msg_type_number_t numCPUInfo, numPrevCPUInfo = 0;
    unsigned numCPUs;
    NSLock *lock;
    
    int mib[2U] = { CTL_HW, HW_NCPU };
    size_t sizeOfNumCPUs = sizeof(numCPUs);
    int status = sysctl(mib, 2U, &numCPUs, &sizeOfNumCPUs, NULL, 0U);
    if (status)
        numCPUs = 1;
    
    lock = [[NSLock alloc] init];
    
    natural_t numCPUsU = 0U;
    kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &numCPUsU, &cpuInfo, &numCPUInfo);
    if (err != KERN_SUCCESS) return nil;
    
    [lock lock];
    
    NSMutableArray *cpus = [NSMutableArray new];
    for (unsigned i = 0U; i < numCPUs; ++i) {
        Float32 inUse, total;
        if (prevCPUInfo) {
            inUse = (
                      (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]   - prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
                      + (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
                      + (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE]   - prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
                      );
            total = inUse + (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
        } else {
            inUse = cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
            total = inUse + cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
        }
        [cpus addObject:@(inUse / total)];
    }
    
    [lock unlock];
    if (prevCPUInfo) {
        size_t prevCpuInfoSize = sizeof(integer_t) * numPrevCPUInfo;
        vm_deallocate(mach_task_self(), (vm_address_t)prevCPUInfo, prevCpuInfoSize);
    }
    
    return cpus;
}

+ (float)cpuUsage {
    float result = 0;
    NSArray *cpus = [self cpuUsagePerProcessor];
    if (cpus.count == 0) return -1.0f;
    
    for (NSNumber *cpu in cpus) {
        result += cpu.floatValue;
    }
    
    return result;
}
@end
