//
//  KMPCoreDataStackTests.m
//  KMPersistence
//
//  Created by Keith Moon on 29/10/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

#import "KMPBaseTests.h"
#import <KMPersistence/KMPersistence.h> 
#import "KMPSingleEntityTest.h"

@interface KMPCoreDataStack (TestHelper)

@property (strong, nonatomic) NSManagedObjectContext *frontendContext;
@property (strong, nonatomic) NSManagedObjectContext *backendContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@interface KMPCoreDataStackTests : KMPBaseTests

@property (nonatomic, strong) KMPCoreDataStack *inMemoryStack;
@property (nonatomic, strong) KMPCoreDataStack *onDiskStack;
@property (nonatomic, strong) NSURL *modelURL;
@property (nonatomic, strong) NSURL *storeURL;
@property (nonatomic, strong) NSURL *existingStoreURL;
@property (nonatomic, strong) NSString *inMemoryStoreType;
@property (nonatomic, strong) NSString *onDiskStoreType;

@end

@implementation KMPCoreDataStackTests

- (void)setUp {
    [super setUp];
    
    NSString *dbName = @"SingleEntityModel.sqlite";
    self.modelURL = [self.testBundle URLForResource:@"SingleEntityModel" withExtension:@"momd"];
    self.storeURL = [[self databaseStorageDirectory] URLByAppendingPathComponent:dbName];
    self.existingStoreURL = [self.testBundle URLForResource:dbName withExtension:nil];
    self.inMemoryStoreType = NSInMemoryStoreType;
    self.onDiskStoreType = NSSQLiteStoreType;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[self databaseStorageDirectory].path]) {
        [fileManager createDirectoryAtURL:[self databaseStorageDirectory]
              withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    self.inMemoryStack = [[KMPCoreDataStack alloc] initWithModelURL:self.modelURL
                                                  storeURL:self.storeURL
                                          existingStoreURL:nil
                                             withStoreType:self.inMemoryStoreType];
    self.onDiskStack = [[KMPCoreDataStack alloc] initWithModelURL:self.modelURL
                                                          storeURL:self.storeURL
                                                  existingStoreURL:self.existingStoreURL
                                                     withStoreType:self.onDiskStoreType];
}

- (void)tearDown {
    
    self.modelURL = nil;
    self.storeURL = nil;
    self.existingStoreURL = nil;
    self.inMemoryStoreType = nil;
    self.onDiskStoreType = nil;
    self.inMemoryStack = nil;
    self.onDiskStack = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[self databaseStorageDirectory].path]) {
        NSError *removeError;
        [fileManager removeItemAtURL:[self databaseStorageDirectory] error:&removeError];
        NSLog(@"Remove Error: %@", removeError.description);
    }
    
    [super tearDown];
}

#pragma mark - Tests

- (void)testStackHasCorrectStoreURL {
    
    NSURL *stackStoreURL = [self.inMemoryStack.persistentStoreCoordinator URLForPersistentStore:self.inMemoryStack.persistentStoreCoordinator.persistentStores.firstObject];
    XCTAssertTrue([stackStoreURL isEqual:self.storeURL], @"Given storeURL should be used for the creation of a persistent store");
}

- (void)testStackHasCorrectStoreType {
    
    NSPersistentStore *store = self.inMemoryStack.persistentStoreCoordinator.persistentStores.firstObject;
    XCTAssertTrue([store.type isEqualToString:self.inMemoryStoreType], @"Given storeType should be used for the creation of a persistent store");
}

- (void)testStackHasCorrectModel {
    
    NSArray *entities = self.inMemoryStack.managedObjectModel.entities;
    XCTAssertTrue(entities.count == 1, @"Stack should have one entity, given a modelURL with 1 entity");
    NSEntityDescription *entity = entities.firstObject;
    XCTAssertTrue([entity.name isEqualToString:@"KMPSingleEntityTest"], @"Stack should have the entity at the given modelURL");
}

- (void)testContextHaveTheSamePSC {
    
    XCTAssertTrue([self.inMemoryStack.frontendContext.persistentStoreCoordinator isEqual:self.inMemoryStack.backendContext.persistentStoreCoordinator], @"Stack contexts should have the same PSC");
}

- (void)testStoreExistsOnFileSystem {
    
    // Prompt file to be created
    [self.onDiskStack persistentStoreCoordinator];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:self.storeURL.path];
    XCTAssertTrue(fileExists, @"Store should exist at file location");
}

- (void)testModelAmendmentsArePassedBetweenContexts {
    
    KMPCoreDataStack *stack = self.inMemoryStack;
    
    XCTestExpectation *completionHandlerFiresExpectation = [self expectationWithDescription:@"Completion Handler Fired"];
    
    NSString *uniqueProperty = @"test1";
    
    [stack performDataStoreWorkWithBlock:^(NSManagedObjectContext *workContext) {
        
        KMPSingleEntityTest *entity = [KMPSingleEntityTest insertInManagedObjectContext:workContext];
        entity.uniqueProperty = uniqueProperty;
        
    } completion:^{
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[KMPSingleEntityTest entityName]];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K == %@", KMPSingleEntityTestAttributes.uniqueProperty, uniqueProperty];
        NSArray *resultsFromOtherContext = [stack resultsForFetchRequest:fetchRequest];
        
        XCTAssertTrue(resultsFromOtherContext.count == 1, @"Should have object added during work block");
        KMPSingleEntityTest *object = resultsFromOtherContext.firstObject;
        XCTAssertTrue([object.uniqueProperty isEqualToString:uniqueProperty], @"Retrieved object should have the property set during the work block");
        XCTAssertTrue(!stack.frontendContext.hasChanges, @"Frontend context should not have any outstanding changes");
        XCTAssertTrue(!stack.backendContext.hasChanges, @"Backend context should not have any outstanding changes");
        
        [completionHandlerFiresExpectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:3 handler:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)testExistingStoreIsCopiedIntoPlace {
    
    // After setup, onDiskStack should already have 1 object in it, which came from the existing SQLite file.
    NSString *uniqueProperty = @"test1";
    KMPCoreDataStack *stack = self.onDiskStack;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[KMPSingleEntityTest entityName]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K == %@", KMPSingleEntityTestAttributes.uniqueProperty, uniqueProperty];
    NSArray *results= [stack resultsForFetchRequest:fetchRequest];
    
    XCTAssertTrue(results.count == 1, @"Should have object from existing store");
    KMPSingleEntityTest *object = results.firstObject;
    XCTAssertTrue([object.uniqueProperty isEqualToString:uniqueProperty], @"Retrieved object should have the property from existing store");
    
}

#pragma mark - Helper Methods

- (NSURL *)databaseStorageDirectory {
    return [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"Tests"];
}

@end
