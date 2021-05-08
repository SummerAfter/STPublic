//
//  STHTTPResponse.m
//  STPublic
//
//  Created by Showtime on 2021/5/8.
//

#import "STHttpResponse.h"

@implementation STHttpResponse

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.isSuccess = [aDecoder decodeBoolForKey:@"isSuccess"];
        self.responseTime = [aDecoder decodeDoubleForKey:@"responseTime"];
        self.originalURL = [aDecoder decodeObjectForKey:@"originalURL"];
        self.actuallyURL = [aDecoder decodeObjectForKey:@"actuallyURL"];
        self.responseString = [aDecoder decodeObjectForKey:@"responseString"];
        self.responseStatus = [aDecoder decodeObjectForKey:@"responseStatus"];
        self.parameter = [aDecoder decodeObjectForKey:@"parameter"];
        self.responseHeaders = [aDecoder decodeObjectForKey:@"responseHeaders"];
        self.responseData = [aDecoder decodeObjectForKey:@"responseData"];
        self.extraDic = [aDecoder decodeObjectForKey:@"extraDic"];
        self.errorCode = [aDecoder decodeIntegerForKey:@"errorCode"];
        self.taskIdentifier = [aDecoder decodeIntegerForKey:@"taskIdentifier"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeBool:self.isSuccess forKey:@"isSuccess"];
    [aCoder encodeDouble:self.responseTime forKey:@"responseTime"];
    [aCoder encodeObject:self.originalURL forKey:@"originalURL"];
    [aCoder encodeObject:self.actuallyURL forKey:@"actuallyURL"];
    [aCoder encodeObject:self.responseString forKey:@"responseString"];
    [aCoder encodeObject:self.message forKey:@"message"];
    [aCoder encodeObject:self.responseStatus forKey:@"responseStatus"];
    [aCoder encodeObject:self.parameter forKey:@"parameter"];
    [aCoder encodeObject:self.responseHeaders forKey:@"responseHeaders"];
    [aCoder encodeObject:self.responseData forKey:@"responseData"];
    [aCoder encodeObject:self.extraDic forKey:@"extraDic"];
    [aCoder encodeInteger:self.errorCode forKey:@"errorCode"];
    [aCoder encodeInteger:self.taskIdentifier forKey:@"taskIdentifier"];
}

@end
