//
//  KMNResponse.h
//  KMNetworking
//
//  Created by Keith Moon on 31/10/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

#import <KMCore/KMCore.h>
#import "KMNRequestCompletionHandler.h"
#import "KMNResponseDefines.h"

@interface KMNResponse : KMCConcurrentOperation

@property (nonatomic, readonly) NSData *receivedData;
@property (nonatomic, readonly) NSURLResponse *response;
@property (nonatomic, readonly) NSHTTPURLResponse *httpResponse;
@property (nonatomic, copy) KMNRequestCompletionHandler backgroundCompletionHandler;
@property (nonatomic, strong) NSProgress *progress;
@property (nonatomic, assign) BOOL expectJSON;

+ (instancetype)responseWithRespone:(NSURLResponse *)response receivedData:(NSData *)receivedData;
- (instancetype)initWithRespone:(NSURLResponse *)response receivedData:(NSData *)receivedData;

@end
