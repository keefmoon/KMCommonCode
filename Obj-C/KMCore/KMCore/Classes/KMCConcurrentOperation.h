//
//  KMCConcurrentOperation.h
//  KMCore
//
//  Created by Keith Moon on 10/11/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

@import Foundation;

static NSString *keyPathIsExecuting		= @"inExecuting";
static NSString *keyPathIsFinished		= @"isFinished";
static NSString *keyPathIsCancelled		= @"isCancelled";
static NSString *keyPathQueuePriority	= @"queuePriority";

@interface KMCConcurrentOperation : NSOperation <NSCopying>

@property (atomic, readwrite, getter=isCancelled) BOOL cancelled;
@property (atomic, readwrite, getter=isExecuting) BOOL executing;
@property (atomic, readwrite, getter=isFinished) BOOL finished;

@end
