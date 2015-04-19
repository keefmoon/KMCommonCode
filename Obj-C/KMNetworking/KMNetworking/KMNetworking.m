//
//  KMNetworking.m
//  KMNetworking
//
//  Created by Keith Moon on 31/10/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

#import "KMNetworking.h"
#import "KMNRequest.h"

@interface KMNetworking () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSMutableDictionary *dataTaskToRequestMapping;

@end

@implementation KMNetworking

+ (instancetype)sharedManager {
    static KMNetworking *sharedInstance;
    static dispatch_once_t done;
    
    dispatch_once(&done, ^{
        sharedInstance =[[KMNetworking alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Request Enqueuing Methods

- (NSProgress *)enqueueRequestForURL:(NSURL *)url withBackgroundCompletionHandler:(KMNRequestCompletionHandler)completionHandler {
    
    KMNRequest *request = [KMNRequest requestWithURL:url inSession:self.networkSession];
    request.backgroundCompletionHandler = completionHandler;
    [self enqueueRequest:request];
    
    return request.progress;
}

- (NSProgress *)enqueueRequest:(NSURLRequest *)request withBackgroundCompletionHandler:(KMNRequestCompletionHandler)completionHandler {
    
    KMNRequest *tnRequest = [KMNRequest requestWithRequest:request inSession:self.networkSession];
    tnRequest.backgroundCompletionHandler = completionHandler;
    [self enqueueRequest:tnRequest];
    
    return tnRequest.progress;
}

- (void)enqueueJSONRequestForURL:(NSURL *)url withBackgroundCompletionHandler:(KMNRequestCompletionHandler)completionHandler {
    
    KMNRequest *request = [KMNRequest requestWithURL:url inSession:self.networkSession];
    request.backgroundCompletionHandler = completionHandler;
    request.expectJSON = YES;
    [self enqueueRequest:request];
}

- (void)enqueueJSONRequest:(NSURLRequest *)request withBackgroundCompletionHandler:(KMNRequestCompletionHandler)completionHandler {
    
    KMNRequest *tnRequest = [KMNRequest requestWithRequest:request inSession:self.networkSession];
    tnRequest.backgroundCompletionHandler = completionHandler;
    tnRequest.expectJSON = YES;
    [self enqueueRequest:tnRequest];
}

- (void)enqueueRequest:(KMNRequest *)request {
    
    self.dataTaskToRequestMapping[request.dataTask] = request;
    [self.networkQueue addOperation:request];
}

#pragma mark - Accessor Methods

- (NSURLSession *)networkSession {
    
    if (!_networkSession) {
        _networkSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                        delegate:self
                                                   delegateQueue:self.responseProcessingQueue];
    }
    return _networkSession;
}

- (NSOperationQueue *)networkQueue {
    
    if (!_networkQueue) {
        _networkQueue = [NSOperationQueue new];
        _networkQueue.maxConcurrentOperationCount = 4;
    }
    return _networkQueue;
}

- (NSOperationQueue *)responseProcessingQueue {
    
    if (!_responseProcessingQueue) {
        _responseProcessingQueue = [NSOperationQueue new];
    }
    return _responseProcessingQueue;
}

- (NSMutableDictionary *)dataTaskToRequestMapping {
    
    if (!_dataTaskToRequestMapping) {
        _dataTaskToRequestMapping = [NSMutableDictionary dictionary];
    }
    return _dataTaskToRequestMapping;
}

#pragma mark - TNRequestRetrievalMethods

- (KMNRequest *)requestForTask:(NSURLSessionTask *)task {
    return self.dataTaskToRequestMapping[task];
}

#pragma mark - NSURLSessionDataDelegate Methods

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    KMNRequest *request = [self requestForTask:dataTask];
    [request didReceiveResponse:response];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    KMNRequest *request = [self requestForTask:dataTask];
    [request didReceiveData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler {
    
    completionHandler(proposedResponse);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    KMNRequest *request = [self requestForTask:task];
    KMNResponse *response = [request didCompleteRequestWithError:error];
    [self.dataTaskToRequestMapping removeObjectForKey:task];
    
    [self.responseProcessingQueue addOperation:response];
}

@end
