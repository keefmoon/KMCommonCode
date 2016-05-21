//
//  KMNetworking.h
//  KMNetworking
//
//  Created by Keith Moon on 31/10/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

@import Foundation;
#import "KMNRequestCompletionHandler.h"
#import "KMNErrorDefines.h"
#import "KMNResponseDefines.h"
#import "KMNStaticDataTestingProtocol.h"

/*
 *  Required Frameworks:
 *  KMCore
 */

#pragma mark - Network Manager

@interface KMNetworking : NSObject

@property (nonatomic, strong) NSURLSession *networkSession;
@property (nonatomic, strong) NSOperationQueue *networkQueue;
@property (nonatomic, strong) NSOperationQueue *responseProcessingQueue;

+ (instancetype)sharedManager;
- (NSProgress *)enqueueRequestForURL:(NSURL *)url withBackgroundCompletionHandler:(KMNRequestCompletionHandler)completionHandler;
- (NSProgress *)enqueueRequest:(NSURLRequest *)request withBackgroundCompletionHandler:(KMNRequestCompletionHandler)completionHandler;
// Expect JSON response even if content-type is wrong
- (void)enqueueJSONRequestForURL:(NSURL *)url withBackgroundCompletionHandler:(KMNRequestCompletionHandler)completionHandler;
- (void)enqueueJSONRequest:(NSURLRequest *)request withBackgroundCompletionHandler:(KMNRequestCompletionHandler)completionHandler;

@end
