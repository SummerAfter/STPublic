//
//  STAFManager.h
//  STPublic
//
//  Created by Showtime on 2021/5/8.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, STEnumHTTPMethod) {
    kHBHTTPGet = 0,
    kHBHTTPPost = 1,
    kHBHTTPPut = 2,
};


@interface STAFManager : AFHTTPSessionManager

/// 存储 请求返回的task
@property (nonatomic, strong) NSMutableDictionary *taksDic;

@property (nonatomic, strong) NSMutableDictionary *urlDic;
/// 递归锁
@property (nonatomic, strong) NSRecursiveLock *recursiveLock;

@property (strong, nonatomic, nonnull) dispatch_semaphore_t reqGWLock;

+ (STAFManager *_Nonnull)defaultNetManager;

- (NSURLSessionDataTask *)taskWithHTTPMethod:(STEnumHTTPMethod)method
                                   URLString:(NSString *_Nullable)URLString
                                  parameters:(id _Nullable)parameters
                                     headers:(nullable NSDictionary<NSString *, NSString *> *)headers
                                     success:(nullable void (^)(NSURLSessionDataTask *_Nullable task, id _Nullable responseObject))success
                                     failure:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *_Nullable error))failure;
@end

NS_ASSUME_NONNULL_END
