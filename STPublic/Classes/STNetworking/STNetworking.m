//
//  STNetworking.m
//  STPublic
//
//  Created by Showtime on 2021/5/8.
//

#import "STNetworking.h"
#import "NSString+STKit.h"
#import "NSData+STKit.h"
#import "NSDictionary+STKit.h"
#import "STUtils.h"
#import <YYCache/YYDiskCache.h>

static const NSInteger kDefaultCacheMaxCacheCount = 1024 * 1024 * 5; // 5 M

#define ST_NetworkingCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]


@implementation STNetworking

//同时发起相同请求不会 被 cancel
+ (NSURLSessionDataTask *)requestAddingWithURL:(NSString *)url
                                        method:(STEnumHTTPMethod)method
                                  parameterDic:(NSDictionary *)parameter
                                  successBlock:(SuccessHBBlock)successBlock
                                  failureBlock:(FailureHBBlock)failBlock {
    STAFManager *manager = [STAFManager defaultNetManager];
    
    //确保 每次请求的 url 和 header 参数值唯一 线程锁
    LOCK(manager.reqGWLock);
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    NSString *changeURL = [self.class changeURL:url];
    if ([NSString isEmpty:changeURL]) {
        UNLOCK(manager.reqGWLock);
        return nil;
    }
    //添加一大串公用的头信息 和 添加自定义认证头信息
    NSDictionary *headers = [self.class getHeadersPerUrl:url parameterDic:parameter];
    //确保 每次请求的 url 和 header 参数值唯一  线程锁
    UNLOCK(manager.reqGWLock);
    
    if (kHBHTTPGet == method) {
        DDLogWarn(@"\n发送GET请求 url: %@ \r\n", changeURL);
        
    } else {
        DDLogWarn(@"\n发送POST请求 url: %@ \r\n", changeURL);
        
        if (parameter) {
            DDLogWarn(@"parameter:%@ \n", parameter);
        }
    }

    // fix: nw_read_request_report [C3] Receive failed with error "Software caused connection abort"
    // 后台挂起时，还未返回数据的api，系统会终止接收respose header ，待恢复时，系统会重新发起原来的request，导致线上401错误，auth_key_used
    __block UIBackgroundTaskIdentifier bgTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        if (bgTaskId != UIBackgroundTaskInvalid) {
            [[UIApplication sharedApplication] endBackgroundTask:bgTaskId];
            bgTaskId = UIBackgroundTaskInvalid;
        }
    }];

    NSURLSessionDataTask *taskRes = [manager taskWithHTTPMethod:method
        URLString:changeURL
        parameters:parameter
        headers:headers
        success:^(NSURLSessionDataTask *task,
                  id _Nullable responseObject) {
            if (task.state == NSURLSessionTaskStateCanceling) {
                // 如果这个operation是被cancel的，那就不用处理回调了。
                DDLogWarn(@"request  被 cancel 了 url :%@", url);
                //移除 task
                [manager.recursiveLock lock];
                [manager.taksDic removeObjectForKey:url];
                [manager.recursiveLock unlock];
                return;
            }
            NSHTTPURLResponse *resp = (NSHTTPURLResponse *) task.response;
            STHttpResponse *response = [[STHttpResponse alloc] init];
            response.responseHeaders = resp.allHeaderFields;
            response.originalURL = url;
            response.actuallyURL = changeURL;
            response.responseTime = [[NSDate date] timeIntervalSince1970] - startTime;
            response.responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            response.parameter = parameter;

            NSDictionary *jsonDic = [NSData toDictionaryForData:responseObject];
            if (jsonDic && [jsonDic isKindOfClass:[NSDictionary class]]) {
                response.responseStatus = [jsonDic objectForKeyBackString:@"response_status"];
                response.isSuccess = [@"success" isEqualToString:response.responseStatus];
                response.message = [jsonDic objectForKeyBackString:@"msg"];

                NSDictionary *jsonInfo = [jsonDic getDictionaryForKeyNoNull:@"info"];
                id resData = [jsonInfo objectForKeyNoNull:@"data"];

                if (response.isSuccess) {
                    response.status = kSTResponseStatusSuccess;
                    if ([resData isKindOfClass:[NSDictionary class]] || [resData isKindOfClass:[NSArray class]]) {
                        response.responseData = resData;
                    } else {
                        response.responseData = nil; //置空 防止闪退
                    }
                    response.extraDic = [jsonInfo objectForKeyNoNull:@"extra"];
                    DDLogInfo(@"收到响应结果 responseTime:%f \r\n  url: %@ \r\n  parameter:%@  res: %@ \r", response.responseTime, [resp.URL absoluteString], parameter, response.responseString);
                } else {
                    response.status = kSTResponseStatusDefault;
                    // show_dialog时，data是json字符串  特殊处理  服务端网关无法返回 data 格式字典
                    if ([@"show_dialog" isEqualToString:response.responseStatus] && [resData isKindOfClass:[NSString class]]) {
                        response.responseData = resData;
                    }
                    //扩展里 具体处理 responseStatus 各种状态  BOOL needBlock = 暂时预留
                    [self.class responseStatusHandle:response];
                    NSString *errorStr = [NSString stringWithFormat:@"返回非 success  responseTime:%f \r\n url: %@   parameter:%@  \r\n res: %@ ", response.responseTime, [resp.URL absoluteString], parameter, jsonDic];
                    DDLogWarn(@"\n非 Success response:%@", errorStr);
                }
                // 回调
                if (successBlock) {
                    successBlock(response);
                }
                //移除 task
                [manager.recursiveLock lock];
                [manager.taksDic removeObjectForKey:url];
                [manager.recursiveLock unlock];
                
            }  else {
                response.status = kSTResponseStatusJsonError;
                //扩展里 kHBResponseStatusJsonError 上报
                [self.class responseStatusHandle:response];
                NSString *errorStr = [NSString stringWithFormat:@"Error Json Invaild responseTime:%f \r\n  url: %@ \r\n  res: %@ ", response.responseTime, [resp.URL absoluteString], response.responseString];
                DDLogError(@"%@", errorStr);
                failBlock(response);
            }
        
            if (bgTaskId != UIBackgroundTaskInvalid) {
                [[UIApplication sharedApplication] endBackgroundTask:bgTaskId];
                bgTaskId = UIBackgroundTaskInvalid;
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nullable error) {
            if (error && (-999 == error.code)) {
                // 如果这个operation是被cancel的，那就不用处理回调了。
                DDLogError(@"request 2  被 cancel 了 url :%@", url);
                //移除 task
                [manager.recursiveLock lock];
                [manager.taksDic removeObjectForKey:url];
                [manager.recursiveLock unlock];
                return;
            }
            NSHTTPURLResponse *resp = (NSHTTPURLResponse *) task.response;
            STHttpResponse *response = [self.class getFailResponseInfo:resp errorInfo:error];
            response.originalURL = url;
            response.actuallyURL = changeURL;
            response.responseTime = [[NSDate date] timeIntervalSince1970] - startTime;
            response.parameter = parameter;
            response.status = kSTResponseStatusFailure;

            NSString *errorStr = [NSString stringWithFormat:@"Error responseTime:%f  url: %@ \n res: %@ \r\n  ", response.responseTime, [resp.URL absoluteString], response.responseString];
            DDLogError(@"%@", errorStr);

            //扩展里 具体处理 kHBResponseStatusFailure  接口失败上报
            [self.class responseStatusHandle:response];

            if (failBlock) {
                failBlock(response);
            }
            //移除 task
            [manager.recursiveLock lock];
            [manager.taksDic removeObjectForKey:url];
            [manager.recursiveLock unlock];
            if (bgTaskId != UIBackgroundTaskInvalid) {
                [[UIApplication sharedApplication] endBackgroundTask:bgTaskId];
                bgTaskId = UIBackgroundTaskInvalid;
            }
        }];

    // 添加 task
    NSArray *oldTaskArray = [manager.taksDic objectForKey:url];
    NSMutableArray *arr = nil;
    if (oldTaskArray) {
        arr = [NSMutableArray arrayWithObject:taskRes];
        [arr addObjectsFromArray:oldTaskArray];
    } else {
        arr = [NSMutableArray arrayWithObject:taskRes];
    }
    [manager.recursiveLock lock];
    [manager.taksDic setObjectSafe:arr forKeySafe:url];
    [manager.recursiveLock unlock];

    return taskRes;
}

+ (NSURLSessionDataTask *)requestWithURL:(NSString *)url
                                  method:(STEnumHTTPMethod)method
                            parameterDic:(NSDictionary *)parameter
                            successBlock:(SuccessHBBlock)successBlock
                            failureBlock:(FailureHBBlock)failBlock {
    //相同 GET 请求 先取消之前的  暂不处理
    //    if (method == kHBHTTPGet) {
    //        [self.class canCellRequsetWithURL:url];
    //    }

    return [self.class requestAddingWithURL:url
        method:method
        parameterDic:parameter
        successBlock:^(STHttpResponse *response) {
            if (successBlock) {
                successBlock(response);
            }
        }
        failureBlock:^(STHttpResponse *response) {
            if (failBlock) {
                failBlock(response);
            }
        }];
}

+ (NSURLSessionDataTask *)requestWithURL:(NSString *)url method:(STEnumHTTPMethod)method parameterDic:(NSDictionary *)parameter delegate:(id<STNetworkingDelegate>)delegate {
    return [self.class requestWithURL:url
        method:method
        parameterDic:parameter
        successBlock:^(STHttpResponse *response) {
            if (delegate && [delegate respondsToSelector:@selector(networkFinishLoad:)]) {
                [delegate networkFinishLoad:response];
            }
        }
        failureBlock:^(STHttpResponse *response) {
            if (delegate && [delegate respondsToSelector:@selector(networkFailureLoad:)]) {
                [delegate networkFailureLoad:response];
            }
        }];
}

+ (STHttpResponse *)getFailResponseInfo:(NSHTTPURLResponse *)resp errorInfo:(NSError *)error {
    STHttpResponse *response = [[STHttpResponse alloc] init];
    response.responseHeaders = resp.allHeaderFields;
    //NSURLErrorTimedOut
    response.errorCode = resp.statusCode > 0 ? resp.statusCode : error.code;
    //服务端返回的错误具体原始信息
    response.responseString = [[NSString alloc] initWithData:(NSData *) error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
    if ([NSString isEmpty:response.responseString]) {
        NSError *err = error.userInfo[NSUnderlyingErrorKey];
        response.responseString = [[NSString alloc] initWithData:(NSData *) err.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
    }
    if ([NSString isEmpty:response.responseString]) {
        response.responseString = error.description;
    }
    response.message = [NSString stringWithFormat:@">﹏< Network Fail ErrorCode:%d", (int) response.errorCode];
    return response;
}

#pragma mark-- 缓存处理及相关

+ (void)storeCache:(id)responseObject withURL:(NSString *)url {
    YYDiskCache *diskCache = [[YYDiskCache alloc] initWithPath:ST_NetworkingCachePath inlineThreshold:kDefaultCacheMaxCacheCount];
    [diskCache setObject:responseObject forKey:url];
}

+ (id)getCacheWithURL:(NSString *)url {
    YYDiskCache *diskCache = [[YYDiskCache alloc] initWithPath:ST_NetworkingCachePath inlineThreshold:kDefaultCacheMaxCacheCount];
    return [diskCache objectForKey:url];
}

//清空缓存的数据
+ (void)deleteCache {
    YYDiskCache *diskCache = [[YYDiskCache alloc] initWithPath:ST_NetworkingCachePath inlineThreshold:kDefaultCacheMaxCacheCount];
    [diskCache removeAllObjects];
}

//取消 某个url 的所有请求
+ (void)cancelRequsetWithURL:(NSString *)url {
    //移除 task
    STAFManager *manager = [STAFManager defaultNetManager];
    NSArray *arr = [manager.taksDic objectForKey:url];
    if (!arr) {
        return;
    }
    for (NSURLSessionDataTask *task in arr) {
        [task cancel];
    }
    [manager.recursiveLock lock];
    [manager.taksDic removeObjectForKey:url];
    [manager.recursiveLock unlock];
}

#pragma mark--  绕过DNS解析 直接使用ip   只有内部请求才做这个功能
+ (NSString *)changeURL:(NSString *)realURL {
    // 转到 分类中实现 只提供单纯网络请求不实现具体业务需求
    return realURL;
}
#pragma mark - headers

+ (NSDictionary *)getHeadersPerUrl:(NSString *)url parameterDic:(NSDictionary *)parameter {
    // 转到 分类中实现 只提供单纯网络请求不实现具体业务需求
    return nil;
}

#pragma mark - response_status   action
/**
 对服务端返回的 response_status 状态 做相应的统一处理
 @return 是否需要回调 对应的 block  YES success NO fail
 */
+ (BOOL)responseStatusHandle:(STHttpResponse *)response {
    // 默认 需要回调
    return YES;
}

@end
