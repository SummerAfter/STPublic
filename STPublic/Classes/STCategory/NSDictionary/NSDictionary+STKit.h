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

// 安全添加 键值对
- (void)setObjectSafe:(id _Nullable)anObject forKeySafe:(NSString *_Nullable)aKey;

@end

@interface NSMutableDictionary (STKit)

+ (NSMutableDictionary *_Nonnull)attributesWithFont:(UIFont *_Nonnull)font;

+ (NSMutableDictionary *_Nonnull)attributesWithFont:(UIFont *_Nonnull)font
                                      lineBreakMode:(NSLineBreakMode)lineBreakMode;

// 安全添加 键值对
- (void)setObjectSafe:(id _Nullable)anObject forKeySafe:(NSString *_Nullable)aKey;

/**
 key 不一定是NSString
 */
- (void)setObjectSafely:(id _Nullable)anObject forCopyingKeySafely:(id<NSCopying> _Nullable)aKey;

@end


NS_ASSUME_NONNULL_END
