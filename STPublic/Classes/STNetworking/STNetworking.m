//
//  STNetworking.m
//  STPublic
//
//  Created by Showtime on 2021/5/8.
//

#import "STNetworking.h"
#import "NSString+STKit.h"
#import "STUtils.h"
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
    HB_LOCK(manager.reqGWLock);
//    [manager.recursiveLockGW lock];
    //url 添加特殊后缀 或过滤参数等 添加标记 host替换为 ip 等  changeURL
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    NSString *changeURL = [self.class changeURL:url];
    if ([NSString isEmpty:changeURL]) {
    
        HB_UNLOCK(manager.reqGWLock);
//        [manager.recursiveLockGW unlock];
        return nil;
    }
    //添加一大串公用的头信息 和 添加自定义认证头信息
    NSDictionary *headers = [self.class getHeadersPerUrl:url parameterDic:parameter];
    //确保 每次请求的 url 和 header 参数值唯一  线程锁
//    [manager.recursiveLockGW unlock];
    HB_UNLOCK(manager.reqGWLock);
    
//    if (kHBHTTPGet == method) {
//        DDLogWarn(@"\n发送GET请求 url: %@ \r\n", changeURL);
//    } else {
//        DDLogWarn(@"\n发送POST请求 url: %@ \r\n", changeURL);
//        if (parameter) {
//            DDLogWarn(@"parameter:%@ \n", parameter);
//        }
//    }

    //    NSLog(@"head= %@",manager.requestSerializer.HTTPRequestHeaders);

    // fix: nw_read_request_report [C3] Receive failed with error "Software caused connection abort"
    // 后台挂起时，还未返回数据的api，系统会终止接收respose header ，待恢复时，系统会重新发起原来的request，导致线上401错误，auth_key_used
    __block UIBackgroundTaskIdentifier bgTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        if (bgTaskId != UIBackgroundTaskInvalid) {
            [[UIApplication sharedApplication] endBackgroundTask:bgTaskId];
            bgTaskId = UIBackgroundTaskInvalid;
        }
    }];

//    NSURLSessionDataTask *taskRes = [manager taskWithHTTPMethod:method
//        URLString:changeURL
//        parameters:parameter
//        headers:headers
//        success:^(NSURLSessionDataTask *task,
//                  id _Nullable responseObject) {
//            if (task.state == NSURLSessionTaskStateCanceling) {
//                // 如果这个operation是被cancel的，那就不用处理回调了。
//                DDLogWarn(@"request  被 cancel 了 url :%@", url);
//                //移除 task
//                [manager.recursiveLock lock];
//                [manager.taksDic removeObjectForKey:url];
//                [manager.recursiveLock unlock];
//                return;
//            }
//            NSHTTPURLResponse *resp = (NSHTTPURLResponse *) task.response;
//            XHBHTTPResponse *response = [[XHBHTTPResponse alloc] init];
//            response.responseHeaders = resp.allHeaderFields;
//            response.originalURL = url;
//            response.actuallyURL = changeURL;
//            response.responseTime = [[NSDate date] timeIntervalSince1970] - startTime;
//            response.responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            response.parameter = parameter;
//
//            NSDictionary *jsonDic = [NSData toDictionaryForData:responseObject];
//            if (jsonDic && [jsonDic isKindOfClass:[NSDictionary class]]) {
//                response.responseStatus = [jsonDic objectForKeyBackString:@"response_status"];
//                response.isSuccess = [@"success" isEqualToString:response.responseStatus];
//                response.message = [jsonDic objectForKeyBackString:@"msg"];
//
//                NSDictionary *jsonInfo = [jsonDic getDictionaryForKeyNoNull:@"info"];
//                id resData = [jsonInfo objectForKeyNoNull:@"data"];
//
//                if (response.isSuccess) {
//                    response.status = kHBResponseStatusSuccess;
//                    if ([resData isKindOfClass:[NSDictionary class]] || [resData isKindOfClass:[NSArray class]]) {
//                        response.responseData = resData;
//                    } else {
//                        response.responseData = nil; //置空 防止闪退
//                    }
//                    response.extraDic = [jsonInfo objectForKeyNoNull:@"extra"];
//                    DDLogInfo(@"收到响应结果 responseTime:%f \r\n  url: %@ \r\n  parameter:%@  res: %@ \r", response.responseTime, [resp.URL absoluteString], parameter, response.responseString);
//                } else {
//                    response.status = kHBResponseStatusDefault;
//                    // show_dialog时，data是json字符串  特殊处理  服务端网关无法返回 data 格式字典
//                    if ([@"show_dialog" isEqualToString:response.responseStatus] && [resData isKindOfClass:[NSString class]]) {
//                        response.responseData = resData;
//                    }
//                    //扩展里 具体处理 responseStatus 各种状态  BOOL needBlock = 暂时预留
//                    [XHBNetworking responseStatusHandle:response];
//                    NSString *errorStr = [NSString stringWithFormat:@"返回非 success  responseTime:%f \r\n url: %@   parameter:%@  \r\n res: %@ ", response.responseTime, [resp.URL absoluteString], parameter, jsonDic];
//                    DDLogWarn(@"\n非 Success response:%@", errorStr);
//                }
//                // 回调
//                if (successBlock) {
//                    successBlock(response);
//                }
//                //移除 task
//                [manager.recursiveLock lock];
//                [manager.taksDic removeObjectForKey:url];
//                [manager.recursiveLock unlock];
//            } else {
//                response.status = kHBResponseStatusJsonError;
//                //扩展里 kHBResponseStatusJsonError 上报
//                [XHBNetworking responseStatusHandle:response];
//                NSString *errorStr = [NSString stringWithFormat:@"Error Json Invaild responseTime:%f \r\n  url: %@ \r\n  res: %@ ", response.responseTime, [resp.URL absoluteString], response.responseString];
//                DDLogError(@"%@", errorStr);
//                failBlock(response);
//            }
//            if (bgTaskId != UIBackgroundTaskInvalid) {
//                [[UIApplication sharedApplication] endBackgroundTask:bgTaskId];
//                bgTaskId = UIBackgroundTaskInvalid;
//            }
//        }
//        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nullable error) {
//            if (error && (-999 == error.code)) {
//                // 如果这个operation是被cancel的，那就不用处理回调了。
//                DDLogError(@"request 2  被 cancel 了 url :%@", url);
//                //移除 task
//                [manager.recursiveLock lock];
//                [manager.taksDic removeObjectForKey:url];
//                [manager.recursiveLock unlock];
//                return;
//            }
//            NSHTTPURLResponse *resp = (NSHTTPURLResponse *) task.response;
//            XHBHTTPResponse *response = [XHBNetworking getFailResponseInfo:resp errorInfo:error];
//            response.originalURL = url;
//            response.actuallyURL = changeURL;
//            response.responseTime = [[NSDate date] timeIntervalSince1970] - startTime;
//            response.parameter = parameter;
//            response.status = kHBResponseStatusFailure;
//
//            NSString *errorStr = [NSString stringWithFormat:@"Error responseTime:%f  url: %@ \n res: %@ \r\n  ", response.responseTime, [resp.URL absoluteString], response.responseString];
//            DDLogError(@"%@", errorStr);
//
//            //扩展里 具体处理 kHBResponseStatusFailure  接口失败上报
//            [XHBNetworking responseStatusHandle:response];
//
//            if (failBlock) {
//                failBlock(response);
//            }
//            //移除 task
//            [manager.recursiveLock lock];
//            [manager.taksDic removeObjectForKey:url];
//            [manager.recursiveLock unlock];
//            if (bgTaskId != UIBackgroundTaskInvalid) {
//                [[UIApplication sharedApplication] endBackgroundTask:bgTaskId];
//                bgTaskId = UIBackgroundTaskInvalid;
//            }
//        }];

    // 添加 task
//    NSArray *oldTaskArray = [manager.taksDic objectForKey:url];
//    NSMutableArray *arr = nil;
//    if (oldTaskArray) {
//        arr = [NSMutableArray arrayWithObject:taskRes];
//        [arr addObjectsFromArray:oldTaskArray];
//    } else {
//        arr = [NSMutableArray arrayWithObject:taskRes];
//    }
//    [manager.recursiveLock lock];
//    [manager.taksDic setObjectSafe:arr forKeySafe:url];
//    [manager.recursiveLock unlock];

//    return taskRes;
    return nil;
}

#pragma mark - headers

+ (NSDictionary *)getHeadersPerUrl:(NSString *)url parameterDic:(NSDictionary *)parameter {
    // 转到 分类中实现 只提供单纯网络请求不实现具体业务需求
    return nil;
}

@end
