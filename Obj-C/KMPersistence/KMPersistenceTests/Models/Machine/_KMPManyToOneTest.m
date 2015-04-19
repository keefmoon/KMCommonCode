// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KMPManyToOneTest.m instead.

#import "_KMPManyToOneTest.h"

const struct KMPManyToOneTestAttributes KMPManyToOneTestAttributes = {
	.displayName = @"displayName",
	.manyToOneId = @"manyToOneId",
};

const struct KMPManyToOneTestRelationships KMPManyToOneTestRelationships = {
	.topLevel = @"topLevel",
};

const struct KMPManyToOneTestUserInfo KMPManyToOneTestUserInfo = {
	.uniqueAttribute = @"manyToOneId",
};

@implementation KMPManyToOneTestID
@end

@implementation _KMPManyToOneTest

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"KMPManyToOneTest" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"KMPManyToOneTest";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"KMPManyToOneTest" inManagedObjectContext:moc_];
}

- (KMPManyToOneTestID*)objectID {
	return (KMPManyToOneTestID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic displayName;

@dynamic manyToOneId;

@dynamic topLevel;

@end

