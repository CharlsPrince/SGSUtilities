/*!
 *  @file SGSCityTableViewCell.m
 *
 *  @author Created by Lee on 16/10/21.
 *
 *  @copyright 2016年 SouthGIS. All rights reserved.
 */

#import "SGSCityTableViewCell.h"
#import "SGSCityPickerDefine.h"

@implementation SGSCityTableViewCell

+ (CGFloat)topPadding {
    return 4;
}

+ (CGFloat)bottomPadding {
    return 12;
}

+ (CGFloat)cityItemWidth {
    static float itemWidth;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        itemWidth = ((SGSScreenWidth() / 3) - 30);
    });
    return itemWidth;
}

@end
