//
//  UIColor+STKit.h
//  Pods-STPublic_Example
//
//  Created by Showtime on 2021/3/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (STKit)

/// 渐变 颜色
/// @param fromColor 从什么颜色
/// @param toColor 到什么颜色
/// @param height 高亮度
+ (UIColor *)gradualColorFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor withHeight:(int)height;

/// 随机色
+ (UIColor *)randomColor;

/// 16进制颜色
+ (instancetype)colorWithHexString:(NSString*)hexString;

@end

NS_ASSUME_NONNULL_END
