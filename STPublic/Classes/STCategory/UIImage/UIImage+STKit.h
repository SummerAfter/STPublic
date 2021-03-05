//
//  UIImage+STKit.h
//  AFNetworking
//
//  Created by Showtime on 2021/3/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (STKit)
/**
 *  根据比例拉伸image
 *
 *  @param name      image的名称
 *  @param leftScale 拉伸的位置，左边间距占整个宽度的百分比
 *  @param topScale  拉伸的位置，上边间距占整个高度的百分比
 *
 *  @return 拉伸好的UIImage
 */
+ (UIImage *)resizedImageNamed:(NSString *)name leftScale:(CGFloat)leftScale topScale:(CGFloat)topScale;

/**
 *  拉伸中点的image
 *
 *  @param name image的名称
 *
 *  @return 拉伸好的UIImage
 */
+ (UIImage *)resizedImageNamed:(NSString *)name;

/**
 *  根据颜色创建一个纯色图片
 *
 *  @param color 生成纯色图片的颜色
 *
 *  @return 根据传入颜色和尺寸生成的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  根据颜色创建一个纯色图片
 *
 *  @param color 生成纯色图片的颜色
 *  @param size  生成纯色图片的大小
 *
 *  @return 根据传入颜色和尺寸生成的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *  防渲染
 */
+ (UIImage *)imgRenderingModeWithImgName:(NSString *)ImgStr;

/**
 使用图片名称 从本地 mainBundle 中加载 gif 图片
 */
+ (UIImage *)st_animatedGIFNamed:(NSString *)name;

/**
 将 gif 图片 data 转换为 UIImage
 */
+ (UIImage *)st_imageWithGIFData:(NSData *)data;

/**
 是否 gif
 */
- (BOOL)isGIF;
@end

NS_ASSUME_NONNULL_END
