//
//  KMParseSync.m
//  KMParseSync
//
//  Created by Keith Moon on 10/11/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

#import "KMParseSync.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wauto-import"
#pragma clang diagnostic ignored "-Wobjc-interface-ivars"
#pragma clang diagnostic ignored "-Woverriding-method-mismatch"
#pragma clang diagnostic ignored "-Wdocumentation"
#import <Parse/Parse.h>
#pragma clang diagnostic pop

@interface KMParseSync ()

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation KMParseSync

+ (instancetype)sharedInstance {
    static KMParseSync *sharedInstance;
    static dispatch_once_t done;
    
    dispatch_once(&done, ^{
        sharedInstance =[[KMParseSync alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Parse Setup Methods

- (void)setupWithApplicationId:(NSString *)appId andClientKey:(NSString *)clientKey {
    [Parse setApplicationId:appId clientKey:clientKey];
}

- (void)trackAppOpenedWithLaunchOptions:(NSDictionary *)launchOptions {
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
}

#pragma mark - Sync Methods

- (void)syncCoreDataStack:(KMPCoreDataStack *)coreDataStack
    withRemoteObjectClass:(NSString *)objectClass
              andRemoteId:(NSString *)remoteId {
    
    PFObject *rootObject = [PFObject objectWithoutDataWithClassName:objectClass objectId:remoteId];
    [rootObject fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if (error) {
            NSLog(@"Parse Fetch Error: %@", error.description);
            return;
        }
        
        
        
        
    }];
    
    
}



#pragma mark - Accessor Methods

- (NSOperationQueue *)operationQueue {
    
    if (!_operationQueue) {
        _operationQueue = [NSOperationQueue new];
    }
    return _operationQueue;
}

- (void)beginSync {
    
//    LocationSyncOperation *locationSyncOperation = [LocationSyncOperation new];
//    locationSyncOperation.delegate = self;
//    [self.operationQueue addOperation:locationSyncOperation];
    
    //    self.creationOperation = [[AppCreationOperation alloc] init];
    //    self.creationOperation = [[LocationCreationOperation alloc] initWithAppObjectId:@"DyOYbRY8ZI"];
}

//- (void)importWithImporter:(CSVImporter *)importer {
//    
//    [self.operationQueue addOperationWithBlock:^{
//        importer.ignoreFirstLine = YES;
//        [importer startImport];
//        NSLog(@"Import: %@", importer.mutableCreatedObjects);
//    }];
//}

#pragma mark - ParseSyncOperationDelegate Methods

- (void)onwardOperationsForProcessing:(NSArray *)onwardsOperations {
    
    // Could decide if we want to do the onward operation
    
//    for (ParseSyncOperation *operation in onwardsOperations) {
//        operation.delegate = self;
//    }
//    
//    [self.operationQueue addOperations:onwardsOperations waitUntilFinished:NO];
}

@end
