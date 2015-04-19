// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KMPManyToManyTest.m instead.

#import "_KMPManyToManyTest.h"

const struct KMPManyToManyTestAttributes KMPManyToManyTestAttributes = {
	.displayName = @"displayName",
	.manyToManyId = @"manyToManyId",
};

const struct KMPManyToManyTestRelationships KMPManyToManyTestRelationships = {
	.topLevels = @"topLevels",
};

const struct KMPManyToManyTestUserInfo KMPManyToManyTestUserInfo = {
	.uniqueAttribute = @"manyToManyId",
};

@implementation KMPManyToManyTestID
@end

@implementation _KMPManyToManyTest

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"KMPManyToManyTest" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"KMPManyToManyTest";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"KMPManyToManyTest" inManagedObjectContext:moc_];
}

- (KMPManyToManyTestID*)objectID {
	return (KMPManyToManyTestID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic displayName;

@dynamic manyToManyId;

@dynamic topLevels;

- (NSMutableSet*)topLevelsSet {
	[self willAccessValueForKey:@"topLevels"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"topLevels"];

	[self didAccessValueForKey:@"topLevels"];
	return result;
}

@end

