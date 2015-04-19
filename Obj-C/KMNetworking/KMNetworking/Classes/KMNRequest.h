//
//  KMNRequest.h
//  KMNetworking
//
//  Created by Keith Moon on 31/10/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

#import <KMCore/KMCore.h>
#import "KMNRequestCompletionHandler.h"
#import "KMNResponse.h"

@interface KMNRequest : KMCConcurrentOperation

@property (nonatomic, readonly) NSURL *requestURL;
@property (nonatomic, readonly) NSURLRequest *request;
@property (nonatomic, readonly) NSURLSession *session;
@property (nonatomic, readonly) NSURLSessionDataTask *dataTask;
@property (nonatomic, copy) KMNRequestCompletionHandler backgroundCompletionHandler;
@property (nonatomic, strong) NSProgress *progress;
@property (nonatomic, assign) BOOL expectJSON;

+ (instancetype)requestWithURL:(NSURL *)url inSession:(NSURLSession *)session;
+ (instancetype)requestWithRequest:(NSURLRequest *)request inSession:(NSURLSession *)session;
- (instancetype)initWithURL:(NSURL *)url inSession:(NSURLSession *)session;
- (instancetype)initWithRequest:(NSURLRequest *)request inSession:(NSURLSession *)session;
- (void)didReceiveData:(NSData *)data;

- (void)didReceiveResponse:(NSURLResponse *)response;
- (KMNResponse *)didCompleteRequestWithError:(NSError *)error;

@end
