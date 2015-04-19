//
//  NSManagedObject+KMPMapping.m
//  KMPersistence
//
//  Created by Keith Moon on 29/10/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

#import "NSManagedObject+KMPMapping.h"
#import "NSManagedObjectContext+KMPFetchOrInsert.h"
#import "KMPErrorDefines.h"
#import "KMPDateFormatter.h"

const struct TPUserInfoKey TPUserInfoKey = {
    .jsonKey = @"jsonKey",
    .uniqueAttribute = @"uniqueAttribute",
    .prefixParentUnique = @"prefixParentUnique",
    .apiPathFormat = @"apiPathFormat",
    .autoValue = @"autoValue",
    .dateFormat = @"dateFormat",
};

const struct TPUserInfoModifier TPUserInfoModifier = {
    .hash = @"HASH",
};

const struct TPUserInfoAutoValue TPUserInfoAutoValue = {
    .now = @"now",
};

@implementation NSManagedObject (KMPMapping)

#pragma mark - Mapping Methods

- (BOOL)mapResponseDictionary:(NSDictionary *)responseDictionary withError:(NSError *__autoreleasing*)error {
    
    if (!responseDictionary) {
        *error = [NSError errorWithDomain:KMPErrorDomain code:KMPErrorCodeUnableToMapNilDictionary userInfo:nil];
        return NO;
    }
    
    NSMutableArray *allErrors = [NSMutableArray array];
    
    for (NSAttributeDescription *attribute in self.entity.attributesByName.allValues) {
        
        NSString *jsonKey = attribute.userInfo[TPUserInfoKey.jsonKey];
        NSString *autoValue = attribute.userInfo[TPUserInfoKey.autoValue];
        NSString *modifier;
        
        // Check for modifier
        NSRange openBracketRange = [jsonKey rangeOfString:@"("];
        NSRange closeBracketRange = [jsonKey rangeOfString:@")"];
        
        if (openBracketRange.location != NSNotFound && closeBracketRange.location != NSNotFound) {
            
            modifier = [jsonKey substringToIndex:openBracketRange.location];
            NSRange jsonKeyValueRange;
            jsonKeyValueRange.location = openBracketRange.location + openBracketRange.length;
            jsonKeyValueRange.length = closeBracketRange.location - jsonKeyValueRange.location;
            jsonKey = [jsonKey substringWithRange:jsonKeyValueRange];
        }
        
        // Map attributes with jsonKey, but where the Parent Unique isn't set,
        // as parent unique ones will have already been set and we don't want to overwrite
        if (jsonKey && !attribute.userInfo[TPUserInfoKey.prefixParentUnique]) {
            
            id valueObject = responseDictionary;
            
            // Traverse path in jsonKey
            NSArray *pathComponents = [jsonKey pathComponents];
            for (NSString *component in pathComponents) {
                valueObject = valueObject[component];
            }
            
            // Apply Modifier if one existed
            if (modifier) {
                valueObject = [self applyModifier:modifier toValue:valueObject];
            }
            
            if (valueObject) {
                NSError *error = [self setResponseObject:valueObject onAttribute:attribute];
                if (error) {
                    [allErrors addObject:error];
                }
            }
        } else if (autoValue) {
            
            id valueObject = [self autoValues][autoValue];
            if (valueObject) {
                NSError *error = [self setResponseObject:valueObject onAttribute:attribute];
                if (error) {
                    [allErrors addObject:error];
                }
            }
        }
        
    }
    
    for (NSRelationshipDescription *relationship in self.entity.relationshipsByName.allValues) {
        
        NSString *jsonKey = relationship.userInfo[TPUserInfoKey.jsonKey];
        
        // Map attributes with jsonKey, but where the Parent Unique isn't set,
        // as parent unique ones will have already been set and we don't want to overwrite
        if (jsonKey && !relationship.userInfo[TPUserInfoKey.prefixParentUnique]) {
            
            if (relationship.isToMany) {
                
                id valueObject = responseDictionary;
                
                // Traverse path in jsonKey
                NSArray *pathComponents = [jsonKey pathComponents];
                for (NSString *component in pathComponents) {
                    valueObject = valueObject[component];
                }
                
                NSArray *arrayOfEntities = valueObject;
                
                // Check there is something there, so we aren't wiping out data on an less detailed API call
                if (arrayOfEntities) {
                    
                    NSSet *entities = [self mappedEntitiesFromArray:arrayOfEntities toManyRelationship:relationship];
                    
                    if (entities) {
                        [self setValue:entities forKey:relationship.name];
                    }
                }
                
            } else {
                
                id valueObject = responseDictionary;
                
                // Traverse path in jsonKey
                NSArray *pathComponents = [jsonKey pathComponents];
                for (NSString *component in pathComponents) {
                    valueObject = valueObject[component];
                }
                
                NSDictionary *entityDictionary = valueObject;
                
                // Check their is something there, so we aren't wiping out data on an less detailed API call
                if (entityDictionary) {
                    
                    NSManagedObject *entity = [self mappedEntityFromDictionary:entityDictionary toOneRelationship:relationship];
                    
                    if (entity) {
                        [self setValue:entity forKey:relationship.name];
                    }
                    
                }
                
            }
            
        }
    }
    
    if (allErrors.count > 0) {
        if (!*error) {
            *error = [NSError errorWithDomain:KMPErrorDomain
                                         code:KMPErrorCodeCombinedError
                                     userInfo:@{KMPErrorUserInfoKeyErrors : allErrors}];
        }
        return NO;
    }
    
    return YES;
}

- (NSManagedObject *)mapDictionary:(NSDictionary *)entityDictionary
                          toEntity:(NSEntityDescription *)entityDescription {
    
    
    NSString *uniqueAttributeName = entityDescription.userInfo[TPUserInfoKey.uniqueAttribute];
    
    if (uniqueAttributeName && entityDictionary) {
        
        // Get JSON Key for Unique Attribute
        NSPropertyDescription *uniqueProperty = entityDescription.propertiesByName[uniqueAttributeName];
        NSString *propertiesJSONKey = uniqueProperty.userInfo[TPUserInfoKey.jsonKey];
        
        id valueObject = entityDictionary;
        
        // Traverse path in jsonKey
        NSArray *pathComponents = [propertiesJSONKey pathComponents];
        for (NSString *component in pathComponents) {
            valueObject = valueObject[component];
        }
        
        // Prefix with this entities uniqueValue, in case childs value is only unique within the parent
        if (uniqueProperty.userInfo[TPUserInfoKey.prefixParentUnique]) {
            
            NSString *thisEntityValue = [self valueForKey:self.entity.userInfo[TPUserInfoKey.uniqueAttribute]];
            valueObject = [NSString stringWithFormat:@"%@/%@", thisEntityValue, valueObject];
            
        }
        
        NSString *uniqueValue = valueObject;
        
        NSManagedObject *relatedManagedObject = [self.managedObjectContext fetchOrInsertObjectWithClassName:entityDescription.managedObjectClassName
                                                                                      forUniqueAttribute:uniqueAttributeName
                                                                                               withValue:uniqueValue];
        
        NSError *mappingError;
        [relatedManagedObject mapResponseDictionary:entityDictionary withError:&mappingError];
        
        return relatedManagedObject;
        
    } else if (!uniqueAttributeName) {
        
        NSLog(@"NOTE: %@ has no %@", entityDescription.name, TPUserInfoKey.uniqueAttribute);
        
        NSManagedObject *relatedManagedObject = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
        
        NSError *mappingError;
        [relatedManagedObject mapResponseDictionary:entityDictionary withError:&mappingError];
        
        return relatedManagedObject;
    }
    
    return nil;
}

- (NSManagedObject *)mappedEntityFromDictionary:(NSDictionary *)entityDictionary
                              toOneRelationship:(NSRelationshipDescription *)relationship {
    
    
    NSEntityDescription *entity = relationship.destinationEntity;
    return [self mapDictionary:entityDictionary toEntity:entity];
}

- (NSSet *)mappedEntitiesFromArray:(NSArray *)entitiesArray
                toManyRelationship:(NSRelationshipDescription *)relationship {
    
    
    NSMutableSet *entities = [NSMutableSet set];
    
    for (NSDictionary *entityDictionary in entitiesArray) {
        
        NSManagedObject *managedObject = [self mapDictionary:entityDictionary toEntity:relationship.destinationEntity];
        
        if (managedObject) {
            [entities addObject:managedObject];
        }
        
    }
    
    return entities;
}

- (NSError *)setResponseObject:(id)responseObject onAttribute:(NSAttributeDescription *)attribute {
    
    // If the attribute value is already the same as the responseObject, don't re-set it.
    // Should prevent unnecessary updating of objects
    id currentValue = [self valueForKey:attribute.name];
    if ([currentValue isEqual:responseObject]) {
        return nil;
    }
    
    NSError *mappingError = nil;
    
    //BNCLog(BNCLogTypeCoreData, [NSThread currentThread].description, @"Mapping %@ to %@", responseObject, attribute.name);
    if (!responseObject) {
        return [self errorForMappingKey:attribute.name andValue:responseObject];
    }
    
    // Dates arrive in the JSON as numbers or strings
    if (attribute.attributeType == NSDateAttributeType) {
        if ([responseObject isKindOfClass:[NSNumber class]]) {
            responseObject = [NSDate dateWithTimeIntervalSince1970:[responseObject unsignedLongLongValue]];
            
            // Check again for equality
            if ([currentValue isEqual:responseObject]) {
                return nil;
            }
        } else if ([responseObject isKindOfClass:[NSString class]]) {
            
            // Convert from NSString to NSDate using dateformat in UserInfo
            NSString *dateFormat = attribute.userInfo[TPUserInfoKey.dateFormat];
            
            if (dateFormat) {
                
                KMPDateFormatter *dateFormatter = [KMPDateFormatter sharedFormatter];
                dateFormatter.dateFormat = dateFormat;
                NSDate *dateValue = [dateFormatter dateFromString:responseObject];
                if (dateValue) {
                    responseObject = dateValue;
                }
            }
        }
    }
    // Convert JSON entry into NSData for binary type
    else if (attribute.attributeType == NSBinaryDataAttributeType && [responseObject respondsToSelector:@selector(dataUsingEncoding:)]) {
        responseObject = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    // Let the framework try to coerce the value
    @try {
        [self setValue:responseObject forKey:attribute.name];
    }
    @catch (NSException* ex) {
        mappingError = [self errorForMappingKey:attribute.name andValue:responseObject];
        [ex description];
        NSLog(@"Failed to map response object: %@ for attribute: %@. Exception is %@", responseObject, attribute, ex);
    }
    /*
     switch (attribute.attributeType) {
     case NSInteger16AttributeType:
     case NSInteger32AttributeType:
     case NSInteger64AttributeType:
     case NSDecimalAttributeType:
     case NSDoubleAttributeType:
     case NSFloatAttributeType:
     case NSBooleanAttributeType:
     
     if ([responseObject isKindOfClass:[NSNumber class]]) {
     [self setValue:responseObject forKey:attribute.name];
     } else {
     mappingError = [self errorForMappingKey:attribute.name andValue:responseObject];
     BNCLog(BNCLogTypeCoreData, [NSThread currentThread].description,
     @"Trying to save to a number attribute of %@ a non-NSNumber: %@", attribute, responseObject);
     }
     break;
     
     case NSStringAttributeType:
     
     if ([responseObject isKindOfClass:[NSString class]]) {
     [self setValue:responseObject forKey:attribute.name];
     } else {
     mappingError = [self errorForMappingKey:attribute.name andValue:responseObject];
     BNCLog(BNCLogTypeCoreData, [NSThread currentThread].description,
     @"Trying to save to a string attribute of %@ a non-NSString: %@", attribute, responseObject);
     }
     break;
     
     case NSBinaryDataAttributeType:
     
     if ([responseObject isKindOfClass:[NSData class]]) {
     [self setValue:responseObject forKey:attribute.name];
     } else {
     mappingError = [self errorForMappingKey:attribute.name andValue:responseObject];
     BNCLog(BNCLogTypeCoreData, [NSThread currentThread].description,
     @"Trying to save to a binary data attribute of %@ a non-NSData: %@", attribute, responseObject);
     }
     break;
     
     case NSDateAttributeType:
     
     if ([responseObject isKindOfClass:[NSDate class]]) {
     [self setValue:responseObject forKey:attribute.name];
     
     } else if ([responseObject isKindOfClass:[NSString class]]) {
     
     // Convert from NSString to NSDate using dateformat in UserInfo
     NSString *dateFormat = self.entity.userInfo[userInfoDateFormat];
     
     if (dateFormat) {
					
					NSDate *dateValue = [[NSDate managedObjectDateFormatterWithFormat:dateFormat] dateFromString:responseObject];
					[self setValue:dateValue forKey:attribute.name];
					
     } else {
					
					mappingError = [NSError errorWithDomain:BNErrorDomainCoreData
     code:BNErrorCodeNoDateFormat
     userInfo:@{BNErrorUserInfoKeyMappingKey : attribute.name,
     BNErrorUserInfoKeyMappingValue : responseObject}];
					BNCLog(BNCLogTypeCoreData, [NSThread currentThread].description,
     @"No Date Format when trying to save to a date attribute of %@ the value: %@", attribute, responseObject);
     }
     
     } else if ([responseObject isKindOfClass:[NSNumber class]]) {
     
     // Convert from NSNumber to NSDate using timeIntervalSince1970
     NSDate *dateValue = [NSDate dateFromTimestamp:responseObject];
     [self setValue:dateValue forKey:attribute.name];
     
     } else {
     mappingError = [self errorForMappingKey:attribute.name andValue:responseObject];
     BNCLog(BNCLogTypeCoreData, [NSThread currentThread].description,
     @"Trying to save to a date attribute of %@ a non-NSDate: %@", attribute, responseObject);
     }
     break;
     
     default:
     mappingError = [self errorForMappingKey:attribute.name andValue:responseObject];
     BNCLog(BNCLogTypeCoreData, [NSThread currentThread].description,
     @"Trying to save to a unknown attribute type of %@ a response object: %@", attribute, responseObject);
     }*/
    
    return mappingError;
}

- (NSDictionary *)autoValues {
    
    return @{TPUserInfoAutoValue.now : [NSDate date]};
}

- (id)applyModifier:(NSString *)modifier toValue:(id)value {
    
    if ([modifier isEqualToString:TPUserInfoModifier.hash]) {
        value = @([value hash]);
    }
    return value;
}

- (NSError *)errorForMappingKey:(NSString *)key andValue:(NSString *)value {
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    // in case @{} is null, in which case, userInfo will not be null
    [userInfo addEntriesFromDictionary:@{KMPErrorUserInfoKeyMappingKey : key,
                                         KMPErrorUserInfoKeyMappingValue : value}];
    
    return [NSError errorWithDomain:KMPErrorDomain
                               code:KMPErrorCodeIncorrectMappingValue
                           userInfo:userInfo];
}

@end
