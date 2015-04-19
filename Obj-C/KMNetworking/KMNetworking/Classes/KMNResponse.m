//
//  KMNResponse.m
//  KMNetworking
//
//  Created by Keith Moon on 31/10/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

#import "KMNResponse.h"
#import "KMNErrorDefines.h"

@interface KMNResponse ()

@property (nonatomic, readwrite) NSData *receivedData;
@property (nonatomic, readwrite) NSHTTPURLResponse *response;

@end

@implementation KMNResponse

+ (instancetype)responseWithRespone:(NSURLResponse *)response receivedData:(NSData *)receivedData {
    return [[self alloc] initWithRespone:response receivedData:receivedData];
}

- (instancetype)initWithRespone:(NSURLResponse *)response receivedData:(NSData *)receivedData {
    
    self = [super init];
    if (self) {
        _receivedData = receivedData;
        _response = response;
    }
    return self;
}

#pragma mark - Accessor Methods

- (NSHTTPURLResponse *)httpResponse {
    return (NSHTTPURLResponse *)self.response;
}

#pragma mark - Operation Methods

- (void)start {
    
    [super start];
    
    if (self.isCancelled) {
        return;
    }
    
    NSString *contentType = self.httpResponse.allHeaderFields[KMNResponseHeaderKey.contentType];
    NSInteger statusCode = self.httpResponse.statusCode;
    
    id responseObject;
    BOOL successful;
    NSError *error;
    
    if (statusCode != KMNResponseStatusCodeOK) {
        
        successful = NO;
        responseObject = self.receivedData;
        error = [NSError errorWithDomain:KMNErrorDomain code:KMNErrorCodeUnexpectedResponseCode userInfo:nil];
        
    } else if ([contentType hasPrefix:KMNResponseContentType.json] || self.expectJSON) {
        
        responseObject = [NSJSONSerialization JSONObjectWithData:self.receivedData options:NSJSONReadingAllowFragments error:&error];
        if (error) {
            successful = NO;
            NSLog(@"JSON Parsing Error: %@", error.description);
        } else {
            successful = YES;
        }
        
    } else {
        
        responseObject = self.receivedData;
        successful = YES;
        error = nil;
        
    }
    
    if (self.isCancelled) {
        return;
    }
    
    self.backgroundCompletionHandler(successful, self.response, responseObject, error);
    
    self.progress.completedUnitCount++;
    
    self.finished = YES;
}

@end
