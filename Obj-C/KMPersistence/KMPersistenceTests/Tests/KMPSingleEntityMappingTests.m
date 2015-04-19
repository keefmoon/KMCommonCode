//
//  KMPMappingTests.m
//  KMPersistence
//
//  Created by Keith Moon on 30/10/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

#import "KMPBaseTests.h"
#import <KMPersistence/KMPersistence.h>
#import "KMPSingleEntityTest.h"

typedef enum : NSUInteger {
    KMPSingleEntityTestJSONResultCorrect,
    KMPSingleEntityTestJSONResultIncorrect,
    KMPSingleEntityTestJSONResultUpdate,
    KMPSingleEntityTestJSONResultNoUnique
} KMPSingleEntityTestJSONResult;

@interface KMPSingleEntityMappingTests : KMPBaseTests

@property (nonatomic, strong) KMPCoreDataStack *stack;
@property (nonatomic, strong) NSArray *resultsArray;

@end

@implementation KMPSingleEntityMappingTests

#pragma mark - Lifecycle Methods

- (void)setUp {
    [super setUp];
    
    NSURL *modelURL = [self.testBundle URLForResource:@"SingleEntityModel" withExtension:@"momd"];
    NSString *storeType = NSInMemoryStoreType;
    
    self.stack = [[KMPCoreDataStack alloc] initWithModelURL:modelURL
                                                  storeURL:nil
                                          existingStoreURL:nil
                                             withStoreType:storeType];
    self.resultsArray = [self resultsArrayFromDictionary:[self parseJSONWithFileName:@"SingleEntityTest"]];
}

- (void)tearDown {
    
    self.stack = nil;
    self.resultsArray = nil;
    [super tearDown];
}

#pragma mark - Test Methods

- (void)testMappingSingleEntityTestJSON {
    
    XCTestExpectation *completionHandlerFiresExpectation = [self expectationWithDescription:@"Completion Handler Fired"];
    
    NSDictionary *correctResult = self.resultsArray[KMPSingleEntityTestJSONResultCorrect];
    
    [self.stack performDataStoreWorkWithBlock:^(NSManagedObjectContext *workContext) {
        
        KMPSingleEntityTest *object = [KMPSingleEntityTest insertInManagedObjectContext:workContext];
        NSError *mappingError;
        BOOL mapped = [object mapResponseDictionary:correctResult withError:&mappingError];
        if (mappingError) {
            NSLog(@"Mapping Error: %@", mappingError);
        }
        
        XCTAssertTrue(mapped, @"A successful mapping should return YES");
        XCTAssertNil(mappingError, @"A successful mapping should have have nil error");
        
    } completion:^{
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[KMPSingleEntityTest entityName]];
        NSArray *resultsFromOtherContext = [self.stack resultsForFetchRequest:fetchRequest];
        KMPSingleEntityTest *object = resultsFromOtherContext.firstObject;
        
        XCTAssertTrue([object.uniqueProperty isEqualToString:correctResult[KMPSingleEntityTestAttributes.uniqueProperty]], @"After mapping %@.%@ should be %@, but instead it is: %@", [KMPSingleEntityTest entityName], KMPSingleEntityTestAttributes.uniqueProperty, correctResult[KMPSingleEntityTestAttributes.uniqueProperty], object.uniqueProperty);
        XCTAssertTrue([object.stringProperty isEqualToString:correctResult[KMPSingleEntityTestAttributes.stringProperty]], @"After mapping %@.%@ should be %@, but instead it is: %@", [KMPSingleEntityTest entityName], KMPSingleEntityTestAttributes.stringProperty, correctResult[KMPSingleEntityTestAttributes.stringProperty], object.stringProperty);
        XCTAssertTrue([object.stringProperty isEqualToString:correctResult[KMPSingleEntityTestAttributes.stringProperty]], @"After mapping %@.%@ should be %@, but instead it is: %@", [KMPSingleEntityTest entityName], KMPSingleEntityTestAttributes.stringProperty, correctResult[KMPSingleEntityTestAttributes.stringProperty], object.stringProperty);
        XCTAssertTrue([self testNumber:object.decimalProperty isWithinToleranceOfBeingEqualToNumber:correctResult[KMPSingleEntityTestAttributes.decimalProperty]], @"After mapping %@.%@ should be %@, but instead it is: %@", [KMPSingleEntityTest entityName], KMPSingleEntityTestAttributes.decimalProperty, correctResult[KMPSingleEntityTestAttributes.decimalProperty], object.decimalProperty);
        XCTAssertTrue([self testNumber:object.doubleProperty isWithinToleranceOfBeingEqualToNumber:correctResult[KMPSingleEntityTestAttributes.doubleProperty]], @"After mapping %@.%@ should be %@, but instead it is: %@", [KMPSingleEntityTest entityName], KMPSingleEntityTestAttributes.doubleProperty, correctResult[KMPSingleEntityTestAttributes.doubleProperty], object.doubleProperty);
        XCTAssertTrue([self testNumber:object.floatProperty isWithinToleranceOfBeingEqualToNumber:correctResult[KMPSingleEntityTestAttributes.floatProperty]], @"After mapping %@.%@ should be %@, but instead it is: %@", [KMPSingleEntityTest entityName], KMPSingleEntityTestAttributes.floatProperty, correctResult[KMPSingleEntityTestAttributes.floatProperty], object.floatProperty);
        XCTAssertTrue([self testNumber:object.int16Property isWithinToleranceOfBeingEqualToNumber:correctResult[KMPSingleEntityTestAttributes.int16Property]], @"After mapping %@.%@ should be %@, but instead it is: %@", [KMPSingleEntityTest entityName], KMPSingleEntityTestAttributes.int16Property, correctResult[KMPSingleEntityTestAttributes.int16Property], object.int16Property);
        XCTAssertTrue([self testNumber:object.int32Property isWithinToleranceOfBeingEqualToNumber:correctResult[KMPSingleEntityTestAttributes.int32Property]], @"After mapping %@.%@ should be %@, but instead it is: %@", [KMPSingleEntityTest entityName], KMPSingleEntityTestAttributes.int32Property, correctResult[KMPSingleEntityTestAttributes.int32Property], object.int32Property);
        XCTAssertTrue([self testNumber:object.int64Property isWithinToleranceOfBeingEqualToNumber:correctResult[KMPSingleEntityTestAttributes.int64Property]], @"After mapping %@.%@ should be %@, but instead it is: %@", [KMPSingleEntityTest entityName], KMPSingleEntityTestAttributes.int64Property, correctResult[KMPSingleEntityTestAttributes.int64Property], object.int64Property);
        XCTAssertTrue([self testNumber:object.boolProperty isWithinToleranceOfBeingEqualToNumber:correctResult[KMPSingleEntityTestAttributes.boolProperty]], @"After mapping %@.%@ should be %@, but instead it is: %@", [KMPSingleEntityTest entityName], KMPSingleEntityTestAttributes.boolProperty, correctResult[KMPSingleEntityTestAttributes.boolProperty], object.boolProperty);
        
        NSString *dataString = correctResult[KMPSingleEntityTestAttributes.dataProperty];
        NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
        
        XCTAssertTrue([object.dataProperty isEqualToData:data], @"After mapping %@.%@ should be %@, but instead it is: %@", [KMPSingleEntityTest entityName], KMPSingleEntityTestAttributes.dataProperty, data, object.dataProperty);
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'hh:mm:ssZ";
        NSDate *date = [dateFormatter dateFromString:correctResult[KMPSingleEntityTestAttributes.dateFormatProperty]];
        
        XCTAssertTrue([object.dateFormatProperty isEqualToDate:date], @"After mapping %@.%@ should be %@, but instead it is: %@", [KMPSingleEntityTest entityName], KMPSingleEntityTestAttributes.dateFormatProperty, date, object.dateFormatProperty);
        
        XCTAssertTrue([object.dateNowProperty timeIntervalSinceNow] < 1.0, @"After mapping %@.%@ should be now (%@), but instead it is: %@", [KMPSingleEntityTest entityName], KMPSingleEntityTestAttributes.dateFormatProperty, [NSDate date], object.dateFormatProperty);
        
        XCTAssertTrue([object.transformableProperty isEqual:correctResult[KMPSingleEntityTestAttributes.transformableProperty]], @"After mapping %@.%@ should be %@, but instead it is: %@", [KMPSingleEntityTest entityName], KMPSingleEntityTestAttributes.transformableProperty, correctResult[KMPSingleEntityTestAttributes.transformableProperty], object.transformableProperty);
        
        [completionHandlerFiresExpectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:3 handler:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)testIncorrectMappingShouldReturnError {
    
    XCTestExpectation *completionHandlerFiresExpectation = [self expectationWithDescription:@"Completion Handler Fired"];
    
    NSDictionary *incorrectResult = self.resultsArray[KMPSingleEntityTestJSONResultIncorrect];
    
    [self.stack performDataStoreWorkWithBlock:^(NSManagedObjectContext *workContext) {
        
        KMPSingleEntityTest *object = [KMPSingleEntityTest insertInManagedObjectContext:workContext];
        NSError *mappingError;
        BOOL mapped = [object mapResponseDictionary:incorrectResult withError:&mappingError];
        if (mappingError) {
            NSLog(@"Mapping Error: %@", mappingError);
        }
        
        XCTAssertFalse(mapped, @"A unsuccessful mapping should return NO");
        XCTAssertNotNil(mappingError, @"A unsuccessful mapping should return an error");
        XCTAssertTrue([mappingError.domain isEqualToString:KMPErrorDomain], @"Mapping error should have the error domain: %@, instead of %@", KMPErrorDomain, mappingError.domain);
        XCTAssertTrue(mappingError.code == KMPErrorCodeCombinedError, @"Mapping error should have the error code: %@, instead of %@", @(KMPErrorCodeCombinedError), @(mappingError.code));
        XCTAssertNotNil(mappingError.userInfo[KMPErrorUserInfoKeyErrors], @"Mapping error have UserInfo with the key %@", KMPErrorUserInfoKeyErrors);
        
        NSArray *errors = mappingError.userInfo[KMPErrorUserInfoKeyErrors];
        // All but transformable should fail, transformable get ValueTransformed from bool.
        XCTAssertTrue(errors.count == 10, @"Should be errors for each value that couldn't be matched, should have been %@, but there was %@", @11, @(errors.count));
        
        
    } completion:^{
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[KMPSingleEntityTest entityName]];
        NSArray *resultsFromOtherContext = [self.stack resultsForFetchRequest:fetchRequest];
        KMPSingleEntityTest *object = resultsFromOtherContext.firstObject;
        
        XCTAssertNil(object.boolProperty, @"An incorrectly mapped object should have nil for unmapped properies. %@ should be nil, but was %@", KMPSingleEntityTestAttributes.boolProperty, object.boolProperty);
        XCTAssertNil(object.dateFormatProperty, @"An incorrectly mapped object should have nil for unmapped properies. %@ should be nil, but was %@", KMPSingleEntityTestAttributes.dateFormatProperty, object.dateFormatProperty);
        XCTAssertNil(object.doubleProperty, @"An incorrectly mapped object should have nil for unmapped properies. %@ should be nil, but was %@", KMPSingleEntityTestAttributes.doubleProperty, object.doubleProperty);
        XCTAssertNil(object.floatProperty, @"An incorrectly mapped object should have nil for unmapped properies. %@ should be nil, but was %@", KMPSingleEntityTestAttributes.floatProperty, object.floatProperty);
        XCTAssertNil(object.int16Property, @"An incorrectly mapped object should have nil for unmapped properies. %@ should be nil, but was %@", KMPSingleEntityTestAttributes.int16Property, object.int16Property);
        XCTAssertNil(object.int32Property, @"An incorrectly mapped object should have nil for unmapped properies. %@ should be nil, but was %@", KMPSingleEntityTestAttributes.int32Property, object.int32Property);
        XCTAssertNil(object.int64Property, @"An incorrectly mapped object should have nil for unmapped properies. %@ should be nil, but was %@", KMPSingleEntityTestAttributes.int64Property, object.int64Property);
        XCTAssertNil(object.stringProperty, @"An incorrectly mapped object should have nil for unmapped properies. %@ should be nil, but was %@", KMPSingleEntityTestAttributes.stringProperty, object.stringProperty);
        XCTAssertNil(object.dataProperty, @"An incorrectly mapped object should have nil for unmapped properies. %@ should be nil, but was %@", KMPSingleEntityTestAttributes.dataProperty, object.dataProperty);
        XCTAssertNotNil(object.transformableProperty, @"An incorrectly mapped object will still likely map a transformable property. %@ should be not nil", KMPSingleEntityTestAttributes.transformableProperty);
        XCTAssertTrue([object.uniqueProperty isEqualToString:incorrectResult[KMPSingleEntityTestAttributes.uniqueProperty]], @"Unique property should confirm that this incompletely mapped object is the same that was attempted to me mapped.");
        
        [completionHandlerFiresExpectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:3 handler:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)testMappingNilProducesAnError {
    
    XCTestExpectation *completionHandlerFiresExpectation = [self expectationWithDescription:@"Completion Handler Fired"];
    
    [self.stack performDataStoreWorkWithBlock:^(NSManagedObjectContext *workContext) {
        
        KMPSingleEntityTest *object = [KMPSingleEntityTest insertInManagedObjectContext:workContext];
        NSError *mappingError;
        BOOL mapped = [object mapResponseDictionary:nil withError:&mappingError];
        if (mappingError) {
            NSLog(@"Mapping Error: %@", mappingError);
        }
        
        XCTAssertFalse(mapped, @"A unsuccessful mapping with a nil dictionary should return NO");
        XCTAssertNotNil(mappingError, @"A unsuccessful mapping with a nil dictionary should return an error");
        XCTAssertTrue([mappingError.domain isEqualToString:KMPErrorDomain], @"Mapping error should have the error domain: %@, instead of %@", KMPErrorDomain, mappingError.domain);
        XCTAssertTrue(mappingError.code == KMPErrorCodeUnableToMapNilDictionary, @"Mapping error should have the error code: %@, instead of %@", @(KMPErrorCodeUnableToMapNilDictionary), @(mappingError.code));
        
    } completion:^{
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[KMPSingleEntityTest entityName]];
        NSArray *resultsFromOtherContext = [self.stack resultsForFetchRequest:fetchRequest];
        KMPSingleEntityTest *object = resultsFromOtherContext.firstObject;
        
        XCTAssertNil(object.boolProperty, @"An incorrectly mapped object should have nil for unmapped properies. %@ should be nil, but was %@", KMPSingleEntityTestAttributes.boolProperty, object.boolProperty);
        XCTAssertNil(object.dateFormatProperty, @"An incorrectly mapped object should have nil for unmapped properies. %@ should be nil, but was %@", KMPSingleEntityTestAttributes.dateFormatProperty, object.dateFormatProperty);
        XCTAssertNil(object.doubleProperty, @"An incorrectly mapped object should have nil for unmapped properies. %@ should be nil, but was %@", KMPSingleEntityTestAttributes.doubleProperty, object.doubleProperty);
        XCTAssertNil(object.floatProperty, @"An incorrectly mapped object should have nil for unmapped properies. %@ should be nil, but was %@", KMPSingleEntityTestAttributes.floatProperty, object.floatProperty);
        XCTAssertNil(object.int16Property, @"An incorrectly mapped object should have nil for unmapped properies. %@ should be nil, but was %@", KMPSingleEntityTestAttributes.int16Property, object.int16Property);
        XCTAssertNil(object.int32Property, @"An incorrectly mapped object should have nil for unmapped properies. %@ should be nil, but was %@", KMPSingleEntityTestAttributes.int32Property, object.int32Property);
        XCTAssertNil(object.int64Property, @"An incorrectly mapped object should have nil for unmapped properies. %@ should be nil, but was %@", KMPSingleEntityTestAttributes.int64Property, object.int64Property);
        XCTAssertNil(object.stringProperty, @"An incorrectly mapped object should have nil for unmapped properies. %@ should be nil, but was %@", KMPSingleEntityTestAttributes.stringProperty, object.stringProperty);
        XCTAssertNil(object.dataProperty, @"An incorrectly mapped object should have nil for unmapped properies. %@ should be nil, but was %@", KMPSingleEntityTestAttributes.dataProperty, object.dataProperty);
        XCTAssertNil(object.transformableProperty, @"An incorrectly mapped object should have nil for unmapped properies. %@ should be nil, but was %@", KMPSingleEntityTestAttributes.transformableProperty, object.transformableProperty);
        XCTAssertNil(object.uniqueProperty, @"An incorrectly mapped object should have nil for unmapped properies. %@ should be nil, but was %@", KMPSingleEntityTestAttributes.uniqueProperty, object.uniqueProperty);
        
        [completionHandlerFiresExpectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:3 handler:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)testMappingPartialDataOverExistingObjectUpdatesExistingObject {
    
    XCTestExpectation *completionHandlerFiresExpectation = [self expectationWithDescription:@"Completion Handler Fired"];
    
    NSDictionary *correctResult = self.resultsArray[KMPSingleEntityTestJSONResultCorrect];
    NSDictionary *updateResult = self.resultsArray[KMPSingleEntityTestJSONResultUpdate];
    
    [self.stack performDataStoreWorkWithBlock:^(NSManagedObjectContext *workContext) {
        
        KMPSingleEntityTest *object = [KMPSingleEntityTest insertInManagedObjectContext:workContext];
        NSError *mappingError;
        [object mapResponseDictionary:correctResult withError:&mappingError];
        
    } completion:^{
        
        [self.stack performDataStoreWorkWithBlock:^(NSManagedObjectContext *workContext) {
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[KMPSingleEntityTest entityName]];
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K == %@", KMPSingleEntityTestAttributes.uniqueProperty, updateResult[KMPSingleEntityTestAttributes.uniqueProperty]];
            NSArray *resultsFromOtherContext = [self.stack resultsForFetchRequest:fetchRequest];
            KMPSingleEntityTest *object = resultsFromOtherContext.firstObject;
            
            NSError *mappingError;
            BOOL mapped = [object mapResponseDictionary:updateResult withError:&mappingError];
            if (mappingError) {
                NSLog(@"Mapping Error: %@", mappingError);
            }
            
            XCTAssertTrue(mapped, @"A successful mapping should return YES");
            XCTAssertNil(mappingError, @"A successful mapping should have have nil error");
            
        } completion:^{
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[KMPSingleEntityTest entityName]];
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K == %@", KMPSingleEntityTestAttributes.uniqueProperty, updateResult[KMPSingleEntityTestAttributes.uniqueProperty]];
            NSArray *resultsFromOtherContext = [self.stack resultsForFetchRequest:fetchRequest];
            
            XCTAssertTrue(resultsFromOtherContext.count == 1, @"Should only be 1 object with the unique identifier %@, instead there were %@", updateResult[KMPSingleEntityTestAttributes.uniqueProperty], @(resultsFromOtherContext.count));
            
            KMPSingleEntityTest *object = resultsFromOtherContext.firstObject;
            
            // Test Values from first Mapping
            
            XCTAssertTrue([object.uniqueProperty isEqualToString:correctResult[KMPSingleEntityTestAttributes.uniqueProperty]], @"After mapping %@.%@ should be %@, but instead it is: %@", [KMPSingleEntityTest entityName], KMPSingleEntityTestAttributes.uniqueProperty, correctResult[KMPSingleEntityTestAttributes.uniqueProperty], object.uniqueProperty);
            XCTAssertTrue([self testNumber:object.decimalProperty isWithinToleranceOfBeingEqualToNumber:correctResult[KMPSingleEntityTestAttributes.decimalProperty]], @"After mapping %@.%@ should be %@, but instead it is: %@", [KMPSingleEntityTest entityName], KMPSingleEntityTestAttributes.decimalProperty, correctResult[KMPSingleEntityTestAttributes.decimalProperty], object.decimalProperty);
            XCTAssertTrue([self testNumber:object.doubleProperty isWithinToleranceOfBeingEqualToNumber:correctResult[KMPSingleEntityTestAttributes.doubleProperty]], @"After mapping %@.%@ should be %@, but instead it is: %@", [KMPSingleEntityTest entityName], KMPSingleEntityTestAttributes.doubleProperty, correctResult[KMPSingleEntityTestAttributes.doubleProperty], object.doubleProperty);
            XCTAssertTrue([self testNumber:object.floatProperty isWithinToleranceOfBeingEqualToNumber:correctResult[KMPSingleEntityTestAttributes.floatProperty]], @"After mapping %@.%@ should be %@, but instead it is: %@", [KMPSingleEntityTest entityName], KMPSingleEntityTestAttributes.floatProperty, correctResult[KMPSingleEntityTestAttributes.floatProperty], object.floatProperty);
            XCTAssertTrue([self testNumber:object.int16Property isWithinToleranceOfBeingEqualToNumber:correctResult[KMPSingleEntityTestAttributes.int16Property]], @"After mapping %@.%@ should be %@, but instead it is: %@", [KMPSingleEntityTest entityName], KMPSingleEntityTestAttributes.int16Property, correctResult[KMPSingleEntityTestAttributes.int16Property], object.int16Property);
            XCTAssertTrue([self testNumber:object.int32Property isWithinToleranceOfBeingEqualToNumber:correctResult[KMPSingleEntityTestAttributes.int32Property]], @"After mapping %@.%@ should be %@, but instead it is: %@", [KMPSingleEntityTest entityName], KMPSingleEntityTestAttributes.int32Property, correctResult[KMPSingleEntityTestAttributes.int32Property], object.int32Property);
            XCTAssertTrue([self testNumber:object.int64Property isWithinToleranceOfBeingEqualToNumber:correctResult[KMPSingleEntityTestAttributes.int64Property]], @"After mapping %@.%@ should be %@, but instead it is: %@", [KMPSingleEntityTest entityName], KMPSingleEntityTestAttributes.int64Property, correctResult[KMPSingleEntityTestAttributes.int64Property], object.int64Property);
            XCTAssertTrue([self testNumber:object.boolProperty isWithinToleranceOfBeingEqualToNumber:correctResult[KMPSingleEntityTestAttributes.boolProperty]], @"After mapping %@.%@ should be %@, but instead it is: %@", [KMPSingleEntityTest entityName], KMPSingleEntityTestAttributes.boolProperty, correctResult[KMPSingleEntityTestAttributes.boolProperty], object.boolProperty);
            
            NSString *dataString = correctResult[KMPSingleEntityTestAttributes.dataProperty];
            NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
            
            XCTAssertTrue([object.dataProperty isEqualToData:data], @"After mapping %@.%@ should be %@, but instead it is: %@", [KMPSingleEntityTest entityName], KMPSingleEntityTestAttributes.dataProperty, data, object.dataProperty);
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd'T'hh:mm:ssZ";
            NSDate *date = [dateFormatter dateFromString:correctResult[KMPSingleEntityTestAttributes.dateFormatProperty]];
            
            XCTAssertTrue([object.dateFormatProperty isEqualToDate:date], @"After mapping %@.%@ should be %@, but instead it is: %@", [KMPSingleEntityTest entityName], KMPSingleEntityTestAttributes.dateFormatProperty, date, object.dateFormatProperty);
            
            XCTAssertTrue([object.dateNowProperty timeIntervalSinceNow] < 1.0, @"After mapping %@.%@ should be now (%@), but instead it is: %@", [KMPSingleEntityTest entityName], KMPSingleEntityTestAttributes.dateFormatProperty, [NSDate date], object.dateFormatProperty);
            
            XCTAssertTrue([object.transformableProperty isEqual:correctResult[KMPSingleEntityTestAttributes.transformableProperty]], @"After mapping %@.%@ should be %@, but instead it is: %@", [KMPSingleEntityTest entityName], KMPSingleEntityTestAttributes.transformableProperty, correctResult[KMPSingleEntityTestAttributes.transformableProperty], object.transformableProperty);
            
            // Test value from update Mapping
            
            XCTAssertTrue([object.stringProperty isEqualToString:updateResult[KMPSingleEntityTestAttributes.stringProperty]], @"After mapping %@.%@ should be %@, but instead it is: %@", [KMPSingleEntityTest entityName], KMPSingleEntityTestAttributes.stringProperty, updateResult[KMPSingleEntityTestAttributes.stringProperty], object.stringProperty);
            
            [completionHandlerFiresExpectation fulfill];
        }];
        
    }];
    
    [self waitForExpectationsWithTimeout:3 handler:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

@end
