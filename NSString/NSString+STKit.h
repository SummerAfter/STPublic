//
//  NSString+STKit.h
//  STPublic
//
//  Created by Showtime on 2021/5/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(int, STNumberTruncType) {
    STNumberTruncType_Round = 0, // 四舍五入
    STNumberTruncType_Ceil = 1,  // 向上取整
    STNumberTruncType_Floor = 2, // 向下取整
};

/**
 截取浮点小数
 
 @param value 浮点型
 @param type 截取类型
 @param decimals 保留几位小数
 @return 截取后的值
 */
static inline CGFloat st_truncFloat(CGFloat value, STNumberTruncType type, int decimals) {
    if (value == 0) {
        return value;
    }
    CGFloat result = value;
    int unit = 1;
    if (decimals == 1) {
        unit = 10;
    } else if (decimals == 2) {
        unit = 100;
    } else if (decimals == 3) {
        unit = 1000;
    }
    switch (type) {
        case STNumberTruncType_Round:
            result = round(value * unit) / unit;
            break;
        case STNumberTruncType_Ceil:
            result = ceil(value * unit) / unit;
            break;
        case STNumberTruncType_Floor:
            result = floor(value * unit) / unit;
            break;
        default:
            break;
    }

    return result;
}

@interface NSString (STKit)

/// 是否 iP
+ (BOOL)isValidIP:(NSString *)ipStr;

/// 是否 空字符串
+ (BOOL)isEmpty:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
