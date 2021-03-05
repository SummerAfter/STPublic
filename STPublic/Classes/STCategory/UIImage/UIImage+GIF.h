//
//  UIImage+GIF.h
//  AFNetworking
//
//  Created by Showtime on 2021/3/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (GIF)

+ (nullable UIImage *)sd_imageWithGIFData:(nullable NSData *)data;

@end

NS_ASSUME_NONNULL_END
