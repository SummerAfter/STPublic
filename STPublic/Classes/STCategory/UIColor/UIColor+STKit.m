//
//  UIColor+STKit.m
//  Pods-STPublic_Example
//
//  Created by Showtime on 2021/3/3.
//

#import "UIColor+STKit.h"

@implementation UIColor (STKit)

+ (UIColor *)gradualColorFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor withHeight:(int)height {
    CGSize size = CGSizeMake(1, height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();

    NSArray *colors = [NSArray arrayWithObjects:(id) fromColor.CGColor, (id) toColor.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (__bridge CFArrayRef) colors, NULL);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, size.height), 0);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();

    return [UIColor colorWithPatternImage:image];
}

+ (UIColor *)randomColor {
    UIColor *color = [UIColor colorWithRed:(arc4random() %256/256.0) green:(arc4random() %256/256.0) blue:(arc4random() %256/256.0) alpha:1.0];
    return color;
}

+ (instancetype)r:(uint8_t)r g:(uint8_t)g b:(uint8_t)b alphaComponent:(CGFloat)alpha {
    return [[self r:r g:g b:b] colorWithAlphaComponent:alpha];
}

+ (instancetype)r:(uint8_t)r g:(uint8_t)g b:(uint8_t)b {
    return [self r:r g:g b:b a:0xff];
}

+ (instancetype)r:(uint8_t)r g:(uint8_t)g b:(uint8_t)b a:(uint8_t)a {
    return [self colorWithRed:r / 255. green:g / 255. blue:b / 255. alpha:a / 255.];
}

+ (instancetype)rgba:(NSUInteger)rgba {
    return [self r:(rgba >> 24)&0xFF g:(rgba >> 16)&0xFF b:(rgba >> 8)&0xFF a:rgba&0xFF];
}

+ (instancetype)colorWithHexString:(NSString *)hexString {
    if (!hexString)
        return nil;
    
    NSString* hex = [NSString stringWithString:hexString];
    if ([hex hasPrefix:@"#"])
        hex = [hex substringFromIndex:1];
    
    if (hex.length == 6)
        hex = [hex stringByAppendingString:@"FF"];
    else if (hex.length != 8)
        return nil;
    
    uint32_t rgba;
    NSScanner* scanner = [NSScanner scannerWithString:hex];
    [scanner scanHexInt:&rgba];
    return [UIColor rgba:rgba];
}
@end
