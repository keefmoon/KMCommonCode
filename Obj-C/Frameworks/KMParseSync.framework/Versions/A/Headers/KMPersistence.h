//
//  KMPersistence.h
//  KMPersistence
//
//  Created by Keith Moon on 29/10/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

/*
 *  Required Frameworks:
 *  CoreData
 *  KMCore
 */

@import Foundation;
#import "NSManagedObject+KMPMapping.h"
#import "NSManagedObjectContext+KMPFetchOrInsert.h"
#import "KMPCoreDataStack.h"
#import "KMPErrorDefines.h"
#import "KMPDateFormatter.h"
#import "KMPResponseModelMapper.h"

@interface KMPersistence : NSObject

@end
