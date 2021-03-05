//
//  UIImage+STKit.m
//  AFNetworking
//
//  Created by Showtime on 2021/3/4.
//

#import "UIImage+STKit.h"
#import "UIImage+GIF.h"
@implementation UIImage (STKit)

+ (UIImage *)resizedImageNamed:(NSString *)name leftScale:(CGFloat)leftScale topScale:(CGFloat)topScale {
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * leftScale topCapHeight:image.size.height * topScale];
}

+ (UIImage *)resizedImageNamed:(NSString *)name {
    return [self resizedImageNamed:name leftScale:0.5 topScale:0.5];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (size.height == 0 || size.width == 0) {
        NSLog(@"请检查size值,无法正确生成图片-%@", NSStringFromCGSize(size));
    }
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  防渲染
 */
+ (UIImage *)imgRenderingModeWithImgName:(NSString *)ImgStr {
    UIImage *img = [UIImage imageNamed:ImgStr];
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return img;
}

+ (UIImage *)st_animatedGIFNamed:(NSString *)name {
    if (!name) {
        return nil;
    }
    CGFloat scale = [UIScreen mainScreen].scale;
    if (scale > 1.0f) {
        NSString *retinaPath = [[NSBundle mainBundle] pathForResource:[name stringByAppendingString:@"@2x"] ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:retinaPath];
        if (data) {
            return [UIImage st_imageWithGIFData:data];
        }
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
        data = [NSData dataWithContentsOfFile:path];
        if (data) {
            return [UIImage st_imageWithGIFData:data];
        }
        return [UIImage imageNamed:name];
    } else {
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        if (data) {
            return [UIImage st_imageWithGIFData:data];
        }
        return [UIImage imageNamed:name];
    }
}

+ (UIImage *)st_imageWithGIFData:(NSData *)data {
    return [UIImage sd_imageWithGIFData:data];
}

- (BOOL)isGIF {
    return (self.images != nil);
}

@end
