//
//  NSManagedObjectContext+KMPFetchOrInsert.h
//  KMPersistence
//
//  Created by Keith Moon on 28/10/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

@import CoreData;

@interface NSManagedObjectContext (KMPFetchOrInsert)

- (NSManagedObject *)fetchOrInsertObjectWithClassName:(NSString *)className forUniqueAttribute:(NSString *)attributeName withValue:(id)valueObject;
- (NSManagedObject *)fetchObjectWithClassName:(NSString *)className forUniqueAttribute:(NSString *)attributeName withValue:(id)valueObject;
- (NSManagedObject *)insertObjectWithClassName:(NSString *)className forUniqueAttribute:(NSString *)attributeName withValue:(id)valueObject;
- (NSArray *)resultsForFetchRequest:(NSFetchRequest *)fetchRequest;

@end
