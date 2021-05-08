//
//  NSString+STKit.m
//  STPublic
//
//  Created by Showtime on 2021/5/8.
//

#import "NSString+STKit.h"

@implementation NSString (STKit)

+ (BOOL)isEmpty:(NSString *)str {
    if (str == nil || ![str isKindOfClass:[NSString class]]) {
        return YES;
    }
    if ([str length] == 0 || [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

/**
 *判断一个字符串是否是一个IP地址
 **/
+ (BOOL)isValidIP:(NSString *)ipStr {
    if (nil == ipStr) {
        return NO;
    }
    NSArray *ipArray = [ipStr componentsSeparatedByString:@"."];
    if (ipArray.count == 4) {
        for (NSString *ipnumberStr in ipArray) {
            int ipnumber = [ipnumberStr intValue];
            if (!(ipnumber >= 0 && ipnumber <= 255)) {
                return NO;
            }
        }
        return YES;
    }
    return NO;
}

@end
