//
//  KMNRequest.m
//  KMNetworking
//
//  Created by Keith Moon on 31/10/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

#import "KMNRequest.h"

@interface KMNRequest ()

@property (nonatomic, readwrite) NSURL *requestURL;
@property (nonatomic, readwrite) NSURLRequest *request;
@property (nonatomic, readwrite) NSURLSession *session;
@property (nonatomic, readwrite) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSURLResponse *response;

@end

@implementation KMNRequest

+ (instancetype)requestWithURL:(NSURL *)url inSession:(NSURLSession *)session {
    return [[self alloc] initWithURL:url inSession:session];
}

+ (instancetype)requestWithRequest:(NSURLRequest *)request inSession:(NSURLSession *)session {
    return [[self alloc] initWithRequest:request inSession:session];
}

- (instancetype)initWithURL:(NSURL *)url inSession:(NSURLSession *)session {
    
    self = [super init];
    if (self) {
        _requestURL = url;
        _request = [self requestForURL:url];
        _session = session;
    }
    return self;
}

- (instancetype)initWithRequest:(NSURLRequest *)request inSession:(NSURLSession *)session {
    
    self = [super init];
    if (self) {
        _request = request;
        _requestURL = request.URL;
        _session = session;
    }
    return self;
}

- (NSURLRequest *)requestForURL:(NSURL *)url {
    return [NSURLRequest requestWithURL:url];
}

#pragma mark - Accessor Methods

- (NSProgress *)progress {
    
    if (!_progress) {
        
        __weak KMNRequest *weakSelf = self;
        
        _progress = [NSProgress progressWithTotalUnitCount:2];
        _progress.cancellationHandler = ^(void){
            __strong KMNRequest *strongSelf = weakSelf;
            [strongSelf.dataTask cancel];
            [strongSelf cancel];
        };
    }
    return _progress;
}

- (NSURLSessionDataTask *)dataTask {
    if (!_dataTask) {
        _dataTask = [self.session dataTaskWithRequest:self.request];
    }
    return _dataTask;
}

- (NSMutableData *)receivedData {
    
    if (!_receivedData) {
        _receivedData = [NSMutableData new];
    }
    return _receivedData;
}

#pragma mark - Network Methods

- (void)didReceiveResponse:(NSURLResponse *)response {
    self.response = response;
}

- (void)didReceiveData:(NSData *)data {
    
    [self.receivedData appendData:data];
    
    // Maybe update some progress
}

- (KMNResponse *)didCompleteRequestWithError:(NSError *)error {
    
    self.progress.completedUnitCount++;
    
    if (error) {
        NSLog(@"Network Error: %@", error);
        self.backgroundCompletionHandler(NO, self.response, nil, error);
        [self.progress resignCurrent];
        self.finished = YES;
        
        return nil;
    }
    
    // The response will fire the completion block
    KMNResponse *response = [KMNResponse responseWithRespone:self.response receivedData:self.receivedData];
    response.backgroundCompletionHandler = self.backgroundCompletionHandler;
    response.expectJSON = self.expectJSON;
    self.backgroundCompletionHandler = nil;
    
    __weak KMNResponse *weakResponse = response;
    response.progress = self.progress;
    response.progress.cancellationHandler = ^(void) {
        __strong KMNResponse *strongResponse = weakResponse;
        [strongResponse cancel];
    };
    
    self.finished = YES;
    
    return response;
}

#pragma mark - Operation Methods

- (void)start {
    
    [super start];
    
    [self.progress becomeCurrentWithPendingUnitCount:2];
    
    [self.dataTask resume];
}

- (void)setCancelled:(BOOL)cancelled {
    
    [self.dataTask cancel];
    [self.progress resignCurrent];
    
    [super setCancelled:cancelled];
}

@end
