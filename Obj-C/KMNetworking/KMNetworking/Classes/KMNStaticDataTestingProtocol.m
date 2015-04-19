//
//  KMNStaticDataTestingProtocol.m
//  KMNetworking
//
//  Created by Keith Moon on 12/07/2013.
//  Copyright (c) 2013 Keith Moon. All rights reserved.
//

#import "KMNStaticDataTestingProtocol.h"

static NSMutableDictionary *responseToReturnForURL;
static NSMutableDictionary *dataToReturnForURL;

@interface KMNStaticDataTestingProtocol ()

@end

@implementation KMNStaticDataTestingProtocol

+ (void)setResponse:(NSURLResponse *)response forURL:(NSURL *)url {
    
    if (!responseToReturnForURL) {
        responseToReturnForURL = [NSMutableDictionary dictionary];
    }
    responseToReturnForURL[url] = response;
}

+ (void)setData:(NSData *)data forURL:(NSURL *)url {
    
    if (!dataToReturnForURL) {
        dataToReturnForURL = [NSMutableDictionary dictionary];
    }
    dataToReturnForURL[url] = data;
}

+ (void)clearStaticData {
    [responseToReturnForURL removeAllObjects];
    [dataToReturnForURL removeAllObjects];
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    
    for (NSURL *responseURL in responseToReturnForURL.allKeys) {
        if ([responseURL isEqual:request.URL]) {
            return YES;
        }
    }
    
    for (NSURL *dataURL in dataToReturnForURL.allKeys) {
        if ([dataURL isEqual:request.URL]) {
            return YES;
        }
    }
    
	return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    
	return request;
}

- (void)startLoading
{
    NSURLResponse *response = responseToReturnForURL[self.request.URL];
    NSData *data = dataToReturnForURL[self.request.URL];
    
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [[self client] URLProtocol:self didLoadData:data];
    [[self client] URLProtocolDidFinishLoading:self];
}

- (void)stopLoading
{
    
}

@end