//
//  NSManagedObjectContext+KMPFetchOrInsert.m
//  KMPersistence
//
//  Created by Keith Moon on 28/10/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

#import "NSManagedObjectContext+KMPFetchOrInsert.h"

@implementation NSManagedObjectContext (KMPFetchOrInsert)

- (NSManagedObject *)fetchOrInsertObjectWithClassName:(NSString *)className forUniqueAttribute:(NSString *)attributeName withValue:(id)valueObject {
    
    NSManagedObject *mo = [self fetchObjectWithClassName:className forUniqueAttribute:attributeName withValue:valueObject];
    
    if (!mo) {
        mo = [self insertObjectWithClassName:className forUniqueAttribute:attributeName withValue:valueObject];
    }
    return mo;
}

- (NSManagedObject *)fetchObjectWithClassName:(NSString *)className forUniqueAttribute:(NSString *)attributeName withValue:(id)valueObject {
    
    // Ensure both attribute name and value are non-nil, if they aren't return nil.
    if (!attributeName || !valueObject) {
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:className inManagedObjectContext:self];
    [fetchRequest setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", attributeName, valueObject];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *fetchResults = [self executeFetchRequest:fetchRequest error:&error];
    
    // If one unique result, return it.
    if (fetchResults.count == 1)
    {
        NSManagedObject *mo = fetchResults.firstObject;
        [mo setValue:valueObject forKey:attributeName];
        return mo;
    } else if (fetchResults.count > 1) {
        NSLog(@"There's more than one (%@) %@, where %@ = %@", @(fetchResults.count), className, attributeName, valueObject);
        return nil;
    } else {
        return nil;
    }
}

- (NSManagedObject *)insertObjectWithClassName:(NSString *)className forUniqueAttribute:(NSString *)attributeName withValue:(id)valueObject {
    
    NSEntityDescription *description = [NSEntityDescription entityForName:className inManagedObjectContext:self];
    Class ObjectClass = NSClassFromString(className);
    NSManagedObject *mo = [[ObjectClass alloc] initWithEntity:description insertIntoManagedObjectContext:self];
    // After creating assign the unique value
    if (attributeName && valueObject) {
        [mo setValue:valueObject forKey:attributeName];
    }
    
    return mo;
}

- (NSArray *)resultsForFetchRequest:(NSFetchRequest *)fetchRequest {
    NSError *fetchError;
    NSArray *results = [self executeFetchRequest:fetchRequest error:&fetchError];
    if (fetchError) {
        NSLog(@"Fetching Error: %@", fetchError.description);
    }
    return results;
}

@end
