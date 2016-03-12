//
//  CAWNetwork.h
//  FinalReader
//
//  Created by wbuntu on 16/3/12.
//  Copyright © 2016年 wbuntu. All rights reserved.
//
//
#import <Foundation/Foundation.h>
typedef void (^CAWCompletionHandler)(NSData *data);
@interface CAWNetwork : NSObject
@property (nonatomic,strong) NSURLSession *session;
@property (nonatomic,strong) NSOperationQueue *oprationQueue;
+ (instancetype)defaultManager;
- (instancetype)initWithDefaultConfiguration;
- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)confgiuratuon operationQueue:(NSOperationQueue *)operationQueue;
- (void)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(CAWCompletionHandler)handler;
- (void)dataTaskWithUrl:(NSURL *)url completionHandler:(CAWCompletionHandler)handler;
- (void)dataTaskWithString:(NSString *)urlString completionHandler:(CAWCompletionHandler)handler;

- (NSURLSessionDataTask *)TaskWithRequest:(NSURLRequest *)request completionHandler:(CAWCompletionHandler)handler;
- (void)cancelAllTasks;
- (void)pauseAllTasks;
- (void)suspendAllTasks;
@end
