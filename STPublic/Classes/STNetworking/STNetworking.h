//
//  STNetworking.h
//  STPublic
//
//  Created by Showtime on 2021/5/8.
//

#import <Foundation/Foundation.h>
#import "STAFManager.h"
#import "STHttpResponse.h"

typedef void (^SuccessHBBlock)(STHttpResponse *response);
typedef void (^FailureHBBlock)(STHttpResponse *response);


@protocol STNetworkingDelegate <NSObject>

- (void)networkFinishLoad:(STHttpResponse *)response;

- (void)networkFailureLoad:(STHttpResponse *)response;

@end


/**
 Description  网络请求管理类
 */
@interface STNetworking : NSObject
//同时发起相同url的请求不会 被 cancel
+ (NSURLSessionDataTask *)requestAddingWithURL:(NSString *)url
                                        method:(STEnumHTTPMethod)method
                                  parameterDic:(NSDictionary *)parameter
                                  successBlock:(SuccessHBBlock)successBlock
                                  failureBlock:(FailureHBBlock)failBlock;

// 会取消相同的url请求
+ (NSURLSessionDataTask *)requestWithURL:(NSString *)url
                                  method:(STEnumHTTPMethod)method
                            parameterDic:(NSDictionary *)parameter
                            successBlock:(SuccessHBBlock)successBlock
                            failureBlock:(FailureHBBlock)failBlock;

//delegate 方式
+ (NSURLSessionDataTask *)requestWithURL:(NSString *)url
                                  method:(STEnumHTTPMethod)method
                            parameterDic:(NSDictionary *)parameter
                                delegate:(id<STNetworkingDelegate>)delegate;

#pragma mark--  绕过DNS解析 直接使用ip   只有内部请求才做这个功能

+ (NSString *)changeURL:(NSString *)realURL;

/**
 * 缓存处理相关方法(使用url作为标识存取数据)
 */
//获取数据
+ (id)getCacheWithURL:(NSString *)url;

//存储数据
+ (void)storeCache:(id)responseObject withURL:(NSString *)url;

//清空缓存的数据
+ (void)deleteCache;

//取消 某个url 的所有请求
+ (void)cancelRequsetWithURL:(NSString *)url;

@end


