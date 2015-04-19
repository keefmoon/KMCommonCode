//
//  TLDataStoreManager.h
//  KMPersistence
//
//  Created by Keith Moon on 23/10/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

@import Foundation;
@import CoreData;

@interface KMPCoreDataStack : NSObject

- (instancetype)initWithModelURL:(NSURL *)modelURL
                        storeURL:(NSURL *)storeURL
                existingStoreURL:(NSURL *)existingStoreURL
                   withStoreType:(NSString *)storeType;

- (void)performDataStoreWorkWithBlock:(void (^)(NSManagedObjectContext *workContext))workBlock
                           completion:(void(^)())completion;
- (NSArray *)resultsForFetchRequest:(NSFetchRequest *)fetchRequest;
- (NSFetchedResultsController *)fetchedResultsControllerForFetchRequest:(NSFetchRequest *)fetchRequest
                                                 withSectionNameKeyPath:(NSString *)keyPath
                                                           andCacheName:(NSString *)cacheName;

@end
