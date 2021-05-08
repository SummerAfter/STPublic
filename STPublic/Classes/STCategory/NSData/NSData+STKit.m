//
//  NSData+STKit.m
//  STPublic
//
//  Created by Showtime on 2021/5/8.
//

#import "NSData+STKit.h"

@implementation NSData (STKit)

+ (NSDictionary *)toDictionaryForData:(NSData *)jsonData {
    NSError *err = nil;
    if (!jsonData) {
        return nil;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&err];
    if(err) {
        return nil;
    }
    return dic;
}


@end
