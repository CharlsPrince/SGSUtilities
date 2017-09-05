//
//  SGSCityPickerDefine.h
//  Pods
//
//  Created by Lee on 2017/2/6.
//
//

#ifndef SGSCityPickerDefine_h
#define SGSCityPickerDefine_h

#import <UIKit/UIKit.h>

/*! 城市选项cell的背景颜色（浅灰色） */
static inline UIColor * SGSCityPickerItemCellBackgroupdColor() {
    return [UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:1.0];
}

/*! 屏幕大小 */
static inline CGSize SGSScreenSize() {
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

/*! 屏幕宽度 */
static inline CGFloat SGSScreenWidth() {
    return SGSScreenSize().width;
}

/*! 屏幕高度 */
static inline CGFloat SGSScreenHeight() {
    return SGSScreenSize().height;
}

#endif /* SGSCityPickerDefine_h */
