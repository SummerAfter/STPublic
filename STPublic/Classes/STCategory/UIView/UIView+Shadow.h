//
//  UIView+Shadow.h
//  STPublic
//
//  Created by Showtime on 2021/3/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Shadow)
/**
 快速添加阴影

 @param color 阴影颜色
 @param cornerRadius 阴影圆角
 @param shadowRadius 投影参数
 */
- (void)addShadowWithColor:(nullable UIColor *)color cornerRadius:(CGFloat)cornerRadius shadowRadius:(CGFloat)shadowRadius;


- (void)addShadowWithColor:(nullable UIColor *)color;

- (void)addShadowWithColor:(nullable UIColor *)color cornerRadius:(CGFloat)cornerRadius;


@end

NS_ASSUME_NONNULL_END
