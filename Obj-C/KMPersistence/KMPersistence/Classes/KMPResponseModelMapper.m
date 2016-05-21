//
//  KMPResponseModelMapper.m
//  KMPersistence
//
//  Created by Keith Moon on 06/11/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

#import "KMPResponseModelMapper.h"
#import "KMPErrorDefines.h"
#import "NSManagedObjectContext+KMPFetchOrInsert.h"

@interface KMPResponseModelMapper ()

@property (nonatomic) id responseObject;

@end

@implementation KMPResponseModelMapper

- (instancetype)initWithResponseObject:(id)responseObject {
    
    self = [super init];
    if (self) {
        _responseObject = responseObject;
    }
    return self;
}

- (NSArray *)mappedObjectsFromTopLevelEntityName:(NSString *)entityName inContext:(NSManagedObjectContext *)context withError:(NSError *__autoreleasing*)error {
    
    // If data turn it into Dictionary/Array
    if ([self.responseObject isKindOfClass:[NSData class]]) {
        NSError *jsonError;
        self.responseObject = [NSJSONSerialization JSONObjectWithData:self.responseObject options:NSJSONReadingAllowFragments error:&jsonError];
        if (jsonError && error != NULL) {
            *error = jsonError;
            return @[];
        }
    }
    
    // If Dictionary stick it in an array or use the topLevelArrayKey to extract the array
    if ([self.responseObject isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *responseDictionary = (NSDictionary *)self.responseObject;
        
        if (self.topLevelArrayKey && responseDictionary[self.topLevelArrayKey]) {
            self.responseObject = responseDictionary[self.topLevelArrayKey];
        } else {
            self.responseObject = @[responseDictionary];
        }
    }
    
    // Now should always have an array of dictionaries
    if (![self.responseObject isKindOfClass:[NSArray class]] && error != NULL) {
        NSError *incorrectTypeError = [NSError errorWithDomain:KMPErrorDomain
                                                          code:KMPErrorCodeUnsupportedMappingObjectType
                                                      userInfo:@{KMPErrorUserInfoKeyUnsupportedMappingObject : self.responseObject}];
        
        *error = incorrectTypeError;
        return @[];
    }

    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSString *uniqueAttributeName = entity.userInfo[KMPUserInfoKey.uniqueAttribute];
    NSAttributeDescription *uniqueAttribute = entity.attributesByName[uniqueAttributeName];
    NSString *uniqueAttributeKey = uniqueAttribute.userInfo[KMPUserInfoKey.jsonKey];
    
    if (!uniqueAttributeName && error != NULL) {
        NSLog(@"%@ has no %@, therefore cannot be cascade mapped", entityName, KMPUserInfoKey.uniqueAttribute);
        *error = [NSError errorWithDomain:KMPErrorDomain code:KMPErrorCodeNoUniqueAttribute userInfo:@{KMPErrorUserInfoKeyEntity : entity}];
        return @[];
    }
    
    NSMutableArray *mappedObjects = [NSMutableArray array];
    NSMutableArray *allMappingErrors = [NSMutableArray array];
    
    for (NSDictionary *objectDictionary in self.responseObject) {
        
        // Traverse path in jsonKey
        NSString *uniqueAttributeValue;
        NSArray *pathComponents = [uniqueAttributeKey pathComponents];
        for (NSString *component in pathComponents) {
            uniqueAttributeValue = objectDictionary[component];
        }
        
        if (!uniqueAttributeValue) {
            continue;
        }
        
        NSManagedObject *object = [context fetchOrInsertObjectWithClassName:entityName forUniqueAttribute:uniqueAttributeName withValue:uniqueAttributeValue];
        NSError *mappingError;
        [object mapResponseDictionary:objectDictionary withError:&mappingError];
        
        if (mappingError) {
            [allMappingErrors addObject:mappingError];
        }
        
        [mappedObjects addObject:object];
    }
    
    if (allMappingErrors.count > 0 && error != NULL) {
        *error = [NSError errorWithDomain:KMPErrorDomain code:KMPErrorCodeCombinedError userInfo:@{KMPErrorUserInfoKeyErrors : allMappingErrors.copy}];
    }
    
    return mappedObjects.copy;
}

@end
