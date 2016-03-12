//
//  CAWNetwork.m
//  FinalReader
//
//  Created by wbuntu on 16/3/12.
//  Copyright © 2016年 wbuntu. All rights reserved.
//

#import "CAWNetwork.h"
static dispatch_queue_t task_create_queue(){
    static dispatch_queue_t caw_task_creation_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        caw_task_creation_queue = dispatch_queue_create("com.wbuntu.cawnetwork.task.creation", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return caw_task_creation_queue;
}
static dispatch_queue_t task_process_queue(){
    static dispatch_queue_t caw_task_process_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        caw_task_process_queue = dispatch_queue_create("com.wbuntu.cawnetwork.task.process", DISPATCH_QUEUE_CONCURRENT);
    });
    return caw_task_process_queue;
}

@implementation CAWNetwork
+ (instancetype)defaultManager
{
    static CAWNetwork *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}
- (instancetype)init
{
    return [self initWithDefaultConfiguration];
}
- (instancetype)initWithDefaultConfiguration
{
    NSOperationQueue *oprationQueue = [[NSOperationQueue alloc] init];
    oprationQueue.maxConcurrentOperationCount = 1;
    return [self initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] operationQueue:oprationQueue];
}
- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)confgiuratuon operationQueue:(NSOperationQueue *)operationQueue
{
    self = [super init];
    if (self) {
        _oprationQueue = operationQueue;
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:_oprationQueue];
    }
    return self;
}
- (void)dataTaskWithString:(NSString *)urlString completionHandler:(CAWCompletionHandler)handler
{
    return [self dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] completionHandler:handler];
}

- (void)dataTaskWithUrl:(NSURL *)url completionHandler:(CAWCompletionHandler)handler
{
    return[self dataTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:handler];
}

- (void)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(CAWCompletionHandler)handler
{
    CAWCompletionHandler tempHandler  =[handler copy];
    __block NSURLSessionDataTask *task = nil;
    dispatch_async(task_create_queue(), ^{
        task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_async(task_process_queue(), ^{
                //proccess or ignore proccessing
                if (error) {
                    NSLog(@"%@",error);
                }
                else{
                tempHandler(data);
                }
            });
        }];
        [task resume];
    });
}

- (NSURLSessionDataTask *)TaskWithRequest:(NSURLRequest *)request completionHandler:(CAWCompletionHandler)handler
{
    CAWCompletionHandler tempHandler  =[handler copy];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_async(task_process_queue(), ^{
                //proccess or ignore proccessing
                if (error) {
                    NSLog(@"%@",error);
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        tempHandler(data);
                    });
                }
            });
        }];
    return task;
}

- (void)cancelAllTasks
{
    [self.session getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> * _Nonnull dataTasks, NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks) {
        [dataTasks makeObjectsPerformSelector:@selector(cancel)];
    }];
}
- (void)pauseAllTasks
{
    [self.session getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> * _Nonnull dataTasks, NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks) {
        [dataTasks makeObjectsPerformSelector:@selector(pause)];
    }];
}
- (void)suspendAllTasks
{
    [self.session getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> * _Nonnull dataTasks, NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks) {
        [dataTasks makeObjectsPerformSelector:@selector(suspend)];
    }];
}
@end
