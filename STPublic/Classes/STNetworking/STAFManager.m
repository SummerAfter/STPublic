//
//  STAFManager.m
//  STPublic
//
//  Created by Showtime on 2021/5/8.
//

#import "STAFManager.h"
#import "NSString+STKit.h"

@implementation STAFManager

+ (STAFManager *)defaultNetManager {
    static STAFManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // AFHTTPResponseSerializer 该类型直接返回 NSData  基类里为 AFJSONResponseSerializer
        manager = [[STAFManager alloc] init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setCachePolicy:NSURLRequestUseProtocolCachePolicy];
        //设置超时时间 默认15秒
        manager.requestSerializer.timeoutInterval = 15;
        manager.taksDic = [[NSMutableDictionary alloc] init];
        manager.urlDic = [[NSMutableDictionary alloc] init];
        manager.recursiveLock = [[NSRecursiveLock alloc] init];
        manager.reqGWLock = dispatch_semaphore_create(1);

    });
    return manager;
}

- (BOOL)evaluateServerTrust:(SecTrustRef)serverTrust forDomain:(NSString *)domain {
    /*
     * 创建证书校验策略
     */
    NSMutableArray *policies = [NSMutableArray array];
    if (domain) {
        [policies addObject:(__bridge_transfer id) SecPolicyCreateSSL(true, (__bridge CFStringRef) domain)];
    } else {
        [policies addObject:(__bridge_transfer id) SecPolicyCreateBasicX509()];
    }
    /*
     * 绑定校验策略到服务端的证书上
     */
    SecTrustSetPolicies(serverTrust, (__bridge CFArrayRef) policies);
    /*
     * 评估当前serverTrust是否可信任，
     * 官方建议在result = kSecTrustResultUnspecified 或 kSecTrustResultProceed
     * 的情况下serverTrust可以被验证通过，https://developer.apple.com/library/ios/technotes/tn2232/_index.html
     * 关于SecTrustResultType的详细信息请参考SecTrust.h
     */
    SecTrustResultType result;
    SecTrustEvaluate(serverTrust, &result);
    return (result == kSecTrustResultUnspecified || result == kSecTrustResultProceed);
}

/**
 Description  重写基类方法覆盖 用与处理https地鼠功能
 @param session session description
 @param challenge challenge description
 @param completionHandler completionHandler description
 */
#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(nonnull NSURLSessionTask *)task didReceiveChallenge:(nonnull NSURLAuthenticationChallenge *)challenge completionHandler:(nonnull void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *_Nullable))completionHandler {
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;

    // 获取原始域名信息。使用域名代替IP进行校验,解决ip直连证书验证不通过问题
    NSString *host = [[task originalRequest] valueForHTTPHeaderField:@"host"];

    if (![NSString isValidIP:challenge.protectionSpace.host]) {
        host = challenge.protectionSpace.host;
    }

    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        // self.securityPolicy evaluateServerTrust:
        if ([self evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:host]) {
            credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            if (credential) {
                disposition = NSURLSessionAuthChallengeUseCredential;
            } else {
                disposition = NSURLSessionAuthChallengePerformDefaultHandling;
            }
        } else {
            disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
        }
    } else {
        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    }
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}

- (NSURLSessionDataTask *)taskWithHTTPMethod:(STEnumHTTPMethod)method
                                   URLString:(NSString *)URLString
                                  parameters:(id)parameters
                                     headers:(NSDictionary<NSString *,NSString *> *)headers
                                     success:(void (^)(NSURLSessionDataTask * _Nullable, id _Nullable))success
                                     failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nullable))failure {
    NSURLSessionDataTask *task = nil;
    if (kHBHTTPGet == method) {
        task = [self GET:URLString parameters:parameters headers:headers progress:nil success:success failure:failure];
    } else if (kHBHTTPPost == method) {
        task = [self POST:URLString parameters:parameters headers:headers progress:nil success:success failure:failure];
    } else if (kHBHTTPPut == method) {
        task = [self PUT:URLString parameters:parameters headers:headers success:success failure:failure];
    }
    return task;
}
@end
