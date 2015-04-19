//
//  KMPRelationshipMappingTests.m
//  KMPersistence
//
//  Created by Keith Moon on 31/10/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

#import "KMPBaseTests.h"
#import <KMPersistence/KMPersistence.h>
#import "KMPTopLevelTest.h"
#import "KMPOneToOneTest.h"
#import "KMPOneToManyTest.h"
#import "KMPManyToOneTest.h"
#import "KMPManyToManyTest.h"
#import "KMPSecondLevelDeepTest.h"

extern const struct KMPRelationshipJSONKey {
    __unsafe_unretained NSString *id;
    __unsafe_unretained NSString *name;
    __unsafe_unretained NSString *oneToOne;
    __unsafe_unretained NSString *oneToMany;
    __unsafe_unretained NSString *manyToOne;
    __unsafe_unretained NSString *manyToMany;
    __unsafe_unretained NSString *secondLevel;
} KMPRelationshipJSONKey;

const struct KMPRelationshipJSONKey KMPRelationshipJSONKey = {
    .id             = @"id",
    .name           = @"name",
    .oneToOne       = @"oneToOne",
    .oneToMany      = @"oneToMany",
    .manyToOne      = @"manyToOne",
    .manyToMany     = @"manyToMany",
    .secondLevel    = @"secondLevel",
};

typedef enum : NSUInteger {
    KMPRelationshipTestJSONResultCorrect
} KMPRelationshipTestJSONResult;

@interface KMPRelationshipMappingTests : KMPBaseTests

@property (nonatomic, strong) KMPCoreDataStack *stack;
@property (nonatomic, strong) NSArray *resultsArray;

@end

@implementation KMPRelationshipMappingTests

- (void)setUp {
    [super setUp];
    
    NSURL *modelURL = [self.testBundle URLForResource:@"RelationshipModel" withExtension:@"momd"];
    NSString *storeType = NSInMemoryStoreType;
    
    self.stack = [[KMPCoreDataStack alloc] initWithModelURL:modelURL
                                                  storeURL:nil
                                          existingStoreURL:nil
                                             withStoreType:storeType];
    self.resultsArray = [self resultsArrayFromDictionary:[self parseJSONWithFileName:@"RelationshipTest"]];
}

- (void)tearDown {
    
    self.stack = nil;
    self.resultsArray = nil;
    
    [super tearDown];
}

- (void)testOneToOneRelationshipIsFollowedAndMapped {
    
    XCTestExpectation *completionHandlerFiresExpectation = [self expectationWithDescription:@"Completion Handler Fired"];
    
    NSDictionary *correctResult = self.resultsArray[KMPRelationshipTestJSONResultCorrect];
    
    [self.stack performDataStoreWorkWithBlock:^(NSManagedObjectContext *workContext) {
        
        KMPTopLevelTest *object = [KMPTopLevelTest insertInManagedObjectContext:workContext];
        NSError *mappingError;
        BOOL mapped = [object mapResponseDictionary:correctResult withError:&mappingError];
        if (mappingError) {
            NSLog(@"Mapping Error: %@", mappingError);
        }
        
        XCTAssertTrue(mapped, @"A successful mapping should return YES");
        XCTAssertNil(mappingError, @"A successful mapping should have have nil error");
        
    } completion:^{
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[KMPTopLevelTest entityName]];
        NSArray *resultsFromOtherContext = [self.stack resultsForFetchRequest:fetchRequest];
        KMPTopLevelTest *topLevel = resultsFromOtherContext.firstObject;
        
        XCTAssertTrue([topLevel.topLevelId isEqualToString:correctResult[KMPRelationshipJSONKey.id]]);
        XCTAssertTrue([topLevel.displayName isEqualToString:correctResult[KMPRelationshipJSONKey.name]]);
        
        NSDictionary *oneToOneDictionary = correctResult[KMPRelationshipJSONKey.oneToOne];
        KMPOneToOneTest *oneToOneObject = topLevel.oneToOne;
        XCTAssertNotNil(oneToOneObject, @"Mapping of top level object should have cascaded down to %@ object", [KMPOneToOneTest entityName]);
        XCTAssertTrue([oneToOneObject.oneToOneId isEqualToString:oneToOneDictionary[KMPRelationshipJSONKey.id]], @"%@ object should correctly map. %@ should have been %@, but was %@", [KMPOneToOneTest entityName], KMPOneToOneTestAttributes.oneToOneId, oneToOneDictionary[KMPRelationshipJSONKey.id], oneToOneObject.oneToOneId);
        XCTAssertTrue([oneToOneObject.displayName isEqualToString:oneToOneDictionary[KMPRelationshipJSONKey.name]], @"%@ object should correctly map. %@ should have been %@, but was %@", [KMPOneToOneTest entityName], KMPOneToOneTestAttributes.displayName, oneToOneDictionary[KMPRelationshipJSONKey.name], oneToOneObject.displayName);
        
        [completionHandlerFiresExpectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:3 handler:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)testSecondLevelDeepRelationshipIsFollowedAndMapped {
    
    XCTestExpectation *completionHandlerFiresExpectation = [self expectationWithDescription:@"Completion Handler Fired"];
    
    NSDictionary *correctResult = self.resultsArray[KMPRelationshipTestJSONResultCorrect];
    
    [self.stack performDataStoreWorkWithBlock:^(NSManagedObjectContext *workContext) {
        
        KMPTopLevelTest *object = [KMPTopLevelTest insertInManagedObjectContext:workContext];
        NSError *mappingError;
        [object mapResponseDictionary:correctResult withError:&mappingError];
        
    } completion:^{
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[KMPTopLevelTest entityName]];
        NSArray *resultsFromOtherContext = [self.stack resultsForFetchRequest:fetchRequest];
        KMPTopLevelTest *topLevel = resultsFromOtherContext.firstObject;
        KMPOneToOneTest *oneToOne = topLevel.oneToOne;
        KMPSecondLevelDeepTest *secondLevelDeepObject = oneToOne.secondLevel;
        NSDictionary *oneToOneDictionary = correctResult[KMPRelationshipJSONKey.oneToOne];
        NSDictionary *secondLevelDeepDictionary = oneToOneDictionary[KMPRelationshipJSONKey.secondLevel];
        
        XCTAssertNotNil(secondLevelDeepObject, @"Mapping of top level object should have cascaded down to %@ object", [KMPOneToOneTest entityName]);
        XCTAssertTrue([secondLevelDeepObject.secondLevelDeepId isEqualToString:secondLevelDeepDictionary[KMPRelationshipJSONKey.id]], @"%@ object should correctly map. %@ should have been %@, but was %@", [KMPOneToOneTest entityName], KMPSecondLevelDeepTestAttributes.secondLevelDeepId, secondLevelDeepDictionary[KMPRelationshipJSONKey.id], secondLevelDeepObject.secondLevelDeepId);
        XCTAssertTrue([secondLevelDeepObject.displayName isEqualToString:secondLevelDeepDictionary[KMPRelationshipJSONKey.name]], @"%@ object should correctly map. %@ should have been %@, but was %@", [KMPOneToOneTest entityName], KMPSecondLevelDeepTestAttributes.displayName, secondLevelDeepDictionary[KMPRelationshipJSONKey.name], secondLevelDeepObject.displayName);
        
        [completionHandlerFiresExpectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:3 handler:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)testOneToManyRelationshipIsFollowedAndMapped {
    
    XCTestExpectation *completionHandlerFiresExpectation = [self expectationWithDescription:@"Completion Handler Fired"];
    
    NSDictionary *correctResult = self.resultsArray[KMPRelationshipTestJSONResultCorrect];
    
    [self.stack performDataStoreWorkWithBlock:^(NSManagedObjectContext *workContext) {
        
        KMPTopLevelTest *object = [KMPTopLevelTest insertInManagedObjectContext:workContext];
        NSError *mappingError;
        [object mapResponseDictionary:correctResult withError:&mappingError];
        
    } completion:^{
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[KMPTopLevelTest entityName]];
        NSArray *resultsFromOtherContext = [self.stack resultsForFetchRequest:fetchRequest];
        KMPTopLevelTest *topLevel = resultsFromOtherContext.firstObject;
        
        NSDictionary *oneToManyDictionary = correctResult[KMPRelationshipJSONKey.oneToMany];
        KMPOneToManyTest *oneToManyObject = topLevel.oneToMany;
        XCTAssertNotNil(oneToManyObject, @"Mapping of top level object should have cascaded down to %@ object", [KMPOneToManyTest entityName]);
        XCTAssertTrue([oneToManyObject.oneToManyId isEqualToString:oneToManyDictionary[KMPRelationshipJSONKey.id]], @"%@ object should correctly map. %@ should have been %@, but was %@", [KMPOneToManyTest entityName], KMPOneToManyTestAttributes.oneToManyId, oneToManyDictionary[KMPRelationshipJSONKey.id], oneToManyObject.oneToManyId);
        XCTAssertTrue([oneToManyObject.displayName isEqualToString:oneToManyDictionary[KMPRelationshipJSONKey.name]], @"%@ object should correctly map. %@ should have been %@, but was %@", [KMPOneToManyTest entityName], KMPOneToManyTestAttributes.displayName, oneToManyDictionary[KMPRelationshipJSONKey.name], oneToManyObject.displayName);
        
        [completionHandlerFiresExpectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:3 handler:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)testManyToOneRelationshipIsFollowedAndMapped {
    
    XCTestExpectation *completionHandlerFiresExpectation = [self expectationWithDescription:@"Completion Handler Fired"];
    
    NSDictionary *correctResult = self.resultsArray[KMPRelationshipTestJSONResultCorrect];
    
    [self.stack performDataStoreWorkWithBlock:^(NSManagedObjectContext *workContext) {
        
        KMPTopLevelTest *object = [KMPTopLevelTest insertInManagedObjectContext:workContext];
        NSError *mappingError;
        [object mapResponseDictionary:correctResult withError:&mappingError];
        
    } completion:^{
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[KMPTopLevelTest entityName]];
        NSArray *resultsFromOtherContext = [self.stack resultsForFetchRequest:fetchRequest];
        KMPTopLevelTest *topLevel = resultsFromOtherContext.firstObject;
        
        NSArray *manyToOneArray = correctResult[KMPRelationshipJSONKey.manyToOne];
        NSSet *manyToOneSet = topLevel.manyToOnes;
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:KMPManyToOneTestAttributes.manyToOneId ascending:YES];
        NSArray *manyToOneOrdered = [manyToOneSet sortedArrayUsingDescriptors:@[sortDescriptor]];
        
        XCTAssertTrue(manyToOneOrdered.count == 2, @"All %@ objects should be created. Expected %@, but there was %@", [KMPManyToOneTest entityName], @2, @(manyToOneOrdered.count));
        
        NSInteger index = 0;
        for (KMPManyToOneTest *manyToOne in manyToOneOrdered) {
            
            NSDictionary *manyToOneDictionary = manyToOneArray[index];
            
            XCTAssertTrue([manyToOne.manyToOneId isEqualToString:manyToOneDictionary[KMPRelationshipJSONKey.id]], @"%@ object should correctly map. %@ should have been %@, but was %@", [KMPManyToOneTest entityName], KMPManyToOneTestAttributes.manyToOneId, manyToOneDictionary[KMPRelationshipJSONKey.id], manyToOne.manyToOneId);
            XCTAssertTrue([manyToOne.displayName isEqualToString:manyToOneDictionary[KMPRelationshipJSONKey.name]], @"%@ object should correctly map. %@ should have been %@, but was %@", [KMPManyToOneTest entityName], KMPManyToOneTestAttributes.displayName, manyToOneDictionary[KMPRelationshipJSONKey.name], manyToOne.displayName);
            
            index++;
        }
        [completionHandlerFiresExpectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:3 handler:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)testManyToManyRelationshipIsFollowedAndMapped {
    
    XCTestExpectation *completionHandlerFiresExpectation = [self expectationWithDescription:@"Completion Handler Fired"];
    
    NSDictionary *correctResult = self.resultsArray[KMPRelationshipTestJSONResultCorrect];
    
    [self.stack performDataStoreWorkWithBlock:^(NSManagedObjectContext *workContext) {
        
        KMPTopLevelTest *object = [KMPTopLevelTest insertInManagedObjectContext:workContext];
        NSError *mappingError;
        [object mapResponseDictionary:correctResult withError:&mappingError];
        
    } completion:^{
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[KMPTopLevelTest entityName]];
        NSArray *resultsFromOtherContext = [self.stack resultsForFetchRequest:fetchRequest];
        KMPTopLevelTest *topLevel = resultsFromOtherContext.firstObject;
        
        NSArray *manyToManyArray = correctResult[KMPRelationshipJSONKey.manyToMany];
        NSSet *manyToManySet = topLevel.manyToManys;
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:KMPManyToManyTestAttributes.manyToManyId ascending:YES];
        NSArray *manyToManyOrdered = [manyToManySet sortedArrayUsingDescriptors:@[sortDescriptor]];
        
        XCTAssertTrue(manyToManyOrdered.count == 2, @"All %@ objects should be created. Expected %@, but there was %@", [KMPManyToOneTest entityName], @2, @(manyToManyOrdered.count));
        
        NSInteger index = 0;
        for (KMPManyToManyTest *manyToMany in manyToManyOrdered) {
            
            NSDictionary *manyToManyDictionary = manyToManyArray[index];
            
            XCTAssertTrue([manyToMany.manyToManyId isEqualToString:manyToManyDictionary[KMPRelationshipJSONKey.id]], @"%@ object should correctly map. %@ should have been %@, but was %@", [KMPManyToManyTest entityName], KMPManyToManyTestAttributes.manyToManyId, manyToManyDictionary[KMPRelationshipJSONKey.id], manyToMany.manyToManyId);
            XCTAssertTrue([manyToMany.displayName isEqualToString:manyToManyDictionary[KMPRelationshipJSONKey.name]], @"%@ object should correctly map. %@ should have been %@, but was %@", [KMPManyToManyTest entityName], KMPManyToManyTestAttributes.displayName, manyToManyDictionary[KMPRelationshipJSONKey.name], manyToMany.displayName);
            
            index++;
        }
        [completionHandlerFiresExpectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:3 handler:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
