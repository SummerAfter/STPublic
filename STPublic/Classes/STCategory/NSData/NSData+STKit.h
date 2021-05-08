//
//  NSData+STKit.h
//  STPublic
//
//  Created by Showtime on 2021/5/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (STKit)

+ (NSDictionary *)toDictionaryForData:(NSData *)jsonData;

@end

NS_ASSUME_NONNULL_END
