//
//  UIImage+GIF.m
//  AFNetworking
//
//  Created by Showtime on 2021/3/4.
//

#import "UIImage+GIF.h"
#import <SDWebImage/SDImageGIFCoder.h>

@implementation UIImage (GIF)

+ (nullable UIImage *)sd_imageWithGIFData:(nullable NSData *)data {
    if (!data) {
        return nil;
    }
    return [[SDImageGIFCoder sharedCoder] decodedImageWithData:data options:0];
}

@end
