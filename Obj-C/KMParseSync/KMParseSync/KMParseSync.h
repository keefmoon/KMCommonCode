//
//  KMParseSync.h
//  KMParseSync
//
//  Created by Keith Moon on 10/11/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

/*
 *  Required Frameworks:
 *  CoreData
 *  KMCore
 *  KMNetworking
 *  KMPersistence
 */

@import Foundation;
#import <KMPersistence/KMPersistence.h>

@interface KMParseSync : NSObject

+ (instancetype)sharedInstance;
#pragma mark - Parse Setup Methods
- (void)setupWithApplicationId:(NSString *)appId andClientKey:(NSString *)clientKey;
- (void)trackAppOpenedWithLaunchOptions:(NSDictionary *)launchOptions;


- (void)beginSync;
//- (void)importWithImporter:(CSVImporter *)importer;


#pragma mark - Sync Methods
- (void)syncCoreDataStack:(KMPCoreDataStack *)coreDataStack
    withRemoteObjectClass:(NSString *)objectClass
              andRemoteId:(NSString *)remoteId;

@end
