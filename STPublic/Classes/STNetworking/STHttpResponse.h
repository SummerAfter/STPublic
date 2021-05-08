//
//  STHTTPResponse.h
//  STPublic
//
//  Created by Showtime on 2021/5/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Description  网络请求返回信息集合
 */
typedef NS_ENUM(NSInteger, STEnumResponseStatus) {
    kSTResponseStatusDefault = 0,
    kSTResponseStatusSuccess = 1,
    kSTResponseStatusFailure = 2,
};

@interface STHttpResponse : NSObject

@property (nonatomic, assign) STEnumResponseStatus status;
@property (nonatomic, assign) BOOL isSuccess;
@property (nonatomic, assign) NSTimeInterval responseTime;
@property (nonatomic, copy)   NSString *originalURL;
@property (nonatomic, copy)   NSString *actuallyURL; //实际发起的url
@property (nonatomic, copy)   NSString *responseString;
@property (nonatomic, copy)   NSString *message;
@property (nonatomic, copy)   NSString *responseStatus;
@property (nonatomic, strong) NSDictionary *parameter;
@property (nonatomic, strong) NSDictionary *responseHeaders;
@property (nonatomic, strong) NSMutableDictionary *extraDic;
@property (nonatomic, strong) id responseData; //有可能返回字典，也可能返回数组
@property (nonatomic, assign) NSUInteger    taskIdentifier; //请求的唯一ID
@property (nonatomic, assign) NSInteger errorCode;  //网络错误码，包含服务端和客户端

@end

NS_ASSUME_NONNULL_END
