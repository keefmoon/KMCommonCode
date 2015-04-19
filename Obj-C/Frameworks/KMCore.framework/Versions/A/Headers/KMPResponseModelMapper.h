//
//  KMPResponseModelMapper.h
//  KMPersistence
//
//  Created by Keith Moon on 06/11/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

@import Foundation;
#import "NSManagedObject+KMPMapping.h"

@interface KMPResponseModelMapper : NSObject

@property (nonatomic, strong) NSString *topLevelArrayKey;

/**
 Create a mapping object with the data to be mapped
 
 @param responseObject The response object to be mapped, this can be raw NSData (in which case it will be JSON deserialised), NSArray or NSDictionary.
 
 @return The initialed mapping object
 */
- (instancetype)initWithResponseObject:(id)responseObject;

/**
 Map the response data that the object was initialised with to the model.
 
 @param entityName The name of the entity that is at the top level of the response object, mapping will cascade through the object graph from here
 @param context The context to use for the creation of managed objects. NOTE: The process will not save the changes to the context.
 @param error A pointer to error object for any errors encounted during the mapping process. NOTE: The presence of an error object doesn't negate the presence of returned objects
 
 @return An array of objects created during the mapping process
 
 */
- (NSArray *)mappedObjectsFromTopLevelEntityName:(NSString *)entityName inContext:(NSManagedObjectContext *)context withError:(NSError *__autoreleasing*)error;

@end
