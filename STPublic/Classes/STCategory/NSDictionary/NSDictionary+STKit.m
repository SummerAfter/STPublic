//
//  NSDictionary+STKit.m
//  STPublic
//
//  Created by Showtime on 2021/5/8.
//

#import "NSDictionary+STKit.h"
#import "NSString+STKit.h"

@implementation NSDictionary (STKit)

- (NSString *)objectForKeyBackString:(NSString *)aKey {
    if ([NSString isEmpty:aKey]) {
        return nil;
    }
    id object = [self objectForKey:aKey];
    if ([object isKindOfClass:[NSNumber class]]) {
        NSNumber *number = (NSNumber *) object;
        return [NSString stringWithFormat:@"%@", number];
    } else if ([object isKindOfClass:[NSString class]]) {
        return object;
    }

    return nil;
}

- (nullable id)objectForKeyNoNull:(NSString *)aKey {
    if ([NSString isEmpty:aKey]) {
        return nil;
    }
    id object = [self objectForKey:aKey];
    if ([object isKindOfClass:[NSNull class]]) {
        return nil;
    } else {
        return object;
    }
}

// 防止null时 调用发生闪退
- (nullable NSDictionary *)getDictionaryForKeyNoNull:(NSString *_Nullable)aKey {
    id obj = [self objectForKeyNoNull:aKey];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return obj;
    }
    return nil;
}
@end
