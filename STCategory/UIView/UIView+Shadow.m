//
//  UIView+Shadow.m
//  STPublic
//
//  Created by Showtime on 2021/3/3.
//

#import "UIView+Shadow.h"

@implementation UIView (Shadow)
/**
 快速添加阴影
 
 @param color 阴影颜色
 @param cornerRadius 阴影圆角
 @param shadowRadius 投影参数
 */
- (void)addShadowWithColor:(nullable UIColor *)color cornerRadius:(CGFloat)cornerRadius shadowRadius:(CGFloat)shadowRadius{
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = CGSizeMake(0,8);
    self.layer.shadowOpacity = 1;
    self.layer.cornerRadius = cornerRadius;
    self.layer.shadowRadius = shadowRadius;
}

- (void)addShadowWithColor:(nullable UIColor *)color{
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 8;
}

- (void)addShadowWithColor:(nullable UIColor *)color cornerRadius:(CGFloat)cornerRadius{

    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowOpacity = 1;
    self.layer.cornerRadius = cornerRadius;
    self.layer.shadowRadius = self.layer.cornerRadius;
}


@end
