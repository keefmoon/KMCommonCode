//
//  KMCConcurrentOperation.m
//  KMCore
//
//  Created by Keith Moon on 10/11/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

#import "KMCConcurrentOperation.h"

@implementation KMCConcurrentOperation

@synthesize executing = _executing;
@synthesize cancelled = _cancelled;
@synthesize finished = _finished;

#pragma mark - Lifecycle Methods

- (id)copyWithZone:(NSZone *)zone {
    KMCConcurrentOperation *obj = [[self.class allocWithZone:zone] init];
    obj.queuePriority = self.queuePriority;
    obj.completionBlock = self.completionBlock;
    return obj;
}

#pragma mark - NSOperation Methods

- (BOOL)isConcurrent {
    return YES;
}

// Subclasses should call super.
- (void)start {
    self.executing = YES;
}

#pragma mark - Accessor Methods

- (void)setExecuting:(BOOL)executing {
    
    if (_executing == executing) {
        return;
    }
    
    [self willChangeValueForKey:keyPathIsExecuting];
    _executing = executing;
    [self didChangeValueForKey:keyPathIsExecuting];
}

- (BOOL)isExecuting {
    return _executing;
}

- (void)setFinished:(BOOL)finished {
    
    if (_finished == finished) {
        return;
    }
    
    [self setExecuting:NO];
    
    [self willChangeValueForKey:keyPathIsFinished];
    _finished = finished;
    [self didChangeValueForKey:keyPathIsFinished];
}

- (BOOL)isFinished {
    return _finished;
}

- (void)setCancelled:(BOOL)cancelled {
    
    if (_cancelled == cancelled) {
        return;
    }
    
    [self setExecuting:NO];
    
    [self willChangeValueForKey:keyPathIsCancelled];
    _cancelled = cancelled;
    [self didChangeValueForKey:keyPathIsCancelled];
}

- (BOOL)isCancelled {
    return _cancelled;
}

#pragma mark - Cancelling Methods

- (void)cancel {
    
    [super cancel];
    self.cancelled = YES;
}

#pragma mark - Nice Description Methods

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ | Executing: %d | Priority: %@", [super description], self.isExecuting, @(self.queuePriority)];
}

@end
