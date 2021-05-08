//
//  NSDictionary+STKit.h
//  STPublic
//
//  Created by Showtime on 2021/5/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (STKit)

// 强制返回字符串
- (NSString *_Nullable)objectForKeyBackString:(NSString *_Nullable)aKey;

// 防止null时 调用发生闪退
- (nullable id)objectForKeyNoNull:(NSString *_Nullable)aKey;

// 防止null时 调用发生闪退
- (nullable NSDictionary *)getDictionaryForKeyNoNull:(NSString *_Nullable)aKey;

@end

NS_ASSUME_NONNULL_END
