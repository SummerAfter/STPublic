//
//  UILabel+ST.h
//  STPublic
//
//  Created by Showtime on 2021/1/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (ST)

/// 初始化
/// @param font 字体
/// @param textColor 颜色
/// @param alignment 对齐方式
+ (instancetype)labelWithfont: (UIFont *)font textColor:(UIColor *)textColor alignment:(NSTextAlignment)alignment;


@end

NS_ASSUME_NONNULL_END
