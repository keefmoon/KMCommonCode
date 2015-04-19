//
//  TLDataStoreManager.m
//  KMPersistence
//
//  Created by Keith Moon on 23/10/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

#import "KMPCoreDataStack.h"
#import "NSManagedObjectContext+KMPFetchOrInsert.h"
#import "KMPErrorDefines.h"

@interface KMPCoreDataStack ()

@property (nonatomic, strong) NSURL *modelURL;
@property (nonatomic, strong) NSURL *storeURL;
@property (nonatomic, strong) NSURL *existingStoreURL;
@property (nonatomic, strong) NSString *storeType;

@property (strong, nonatomic) NSManagedObjectContext *frontendContext;
@property (strong, nonatomic) NSManagedObjectContext *backendContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation KMPCoreDataStack

- (instancetype)initWithModelURL:(NSURL *)modelURL
                        storeURL:(NSURL *)storeURL
                existingStoreURL:(NSURL *)existingStoreURL
                   withStoreType:(NSString *)storeType {
    
    self = [super init];
    if (self) {
        _modelURL = modelURL;
        _storeURL = storeURL;
        _existingStoreURL = existingStoreURL;
        _storeType = storeType;
    }
    return self;
}

#pragma mark - Amending Model

- (void)performDataStoreWorkWithBlock:(void (^)(NSManagedObjectContext *workContext))workBlock completion:(void(^)())completion {
    
    __weak KMPCoreDataStack *weakSelf = self;
    
    // Perform all ammendments on the background context and merge
    [self.backendContext performBlock:^{
        
        // Creating a strong ref from the weak one to prevent it being nil'd
        // As suggested here:
        // http://dhoerl.wordpress.com/2013/04/23/i-finally-figured-out-weakself-and-strongself/
        __strong KMPCoreDataStack *strongSelf = weakSelf;
        
        NSManagedObjectContext *context = strongSelf.backendContext;
        workBlock(context);
        
        [strongSelf saveContext:context];
        
        [strongSelf.frontendContext performBlock:completion];
    }];
}

#pragma mark - Fetching from Model Methods

- (NSArray *)resultsForFetchRequest:(NSFetchRequest *)fetchRequest {
    return [self.frontendContext resultsForFetchRequest:fetchRequest];
}

- (NSFetchedResultsController *)fetchedResultsControllerForFetchRequest:(NSFetchRequest *)fetchRequest
                                                 withSectionNameKeyPath:(NSString *)keyPath
                                                           andCacheName:(NSString *)cacheName {
    
    return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                               managedObjectContext:self.frontendContext
                                                 sectionNameKeyPath:keyPath cacheName:cacheName];
}

#pragma mark - Core Data stack

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = self.storeURL;
    
    // If database doesn't already exist, retrieve pre-populated database.
    if(self.existingStoreURL && ![[NSFileManager defaultManager] fileExistsAtPath:storeURL.path]) {
        
        NSError *copyError = nil;
        BOOL copySuccess = [[NSFileManager defaultManager] copyItemAtPath:self.existingStoreURL.path toPath:storeURL.path error:&copyError];
        
        if (!copySuccess) {
            NSLog(@"DB copy error: %@", copyError);
        }
    }
    
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    // Don't use write ahead logging
    NSDictionary *options = @{ NSSQLitePragmasOption: @{ @"journal_mode": @"DELETE"}};
    if (![_persistentStoreCoordinator addPersistentStoreWithType:self.storeType configuration:nil URL:storeURL options:options error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:KMPErrorDomain code:KMPErrorCodeCoreDataSetup userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)frontendContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_frontendContext != nil) {
        return _frontendContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _frontendContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _frontendContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    [_frontendContext setPersistentStoreCoordinator:coordinator];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification
                                                      object:self.backendContext
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      [self.frontendContext performBlock:^{
                                                          [self.frontendContext mergeChangesFromContextDidSaveNotification:note];
                                                      }];
                                                  }];
    
    return _frontendContext;
}

- (NSManagedObjectContext *)backendContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_backendContext != nil) {
        return _backendContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _backendContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_backendContext setPersistentStoreCoordinator:coordinator];
    return _backendContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext:(NSManagedObjectContext *)context {
    NSManagedObjectContext *managedObjectContext = self.backendContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
