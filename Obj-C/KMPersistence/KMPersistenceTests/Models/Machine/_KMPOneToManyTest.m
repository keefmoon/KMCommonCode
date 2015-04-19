// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KMPOneToManyTest.m instead.

#import "_KMPOneToManyTest.h"

const struct KMPOneToManyTestAttributes KMPOneToManyTestAttributes = {
	.displayName = @"displayName",
	.oneToManyId = @"oneToManyId",
};

const struct KMPOneToManyTestRelationships KMPOneToManyTestRelationships = {
	.topLevels = @"topLevels",
};

const struct KMPOneToManyTestUserInfo KMPOneToManyTestUserInfo = {
	.uniqueAttribute = @"oneToManyId",
};

@implementation KMPOneToManyTestID
@end

@implementation _KMPOneToManyTest

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"KMPOneToManyTest" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"KMPOneToManyTest";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"KMPOneToManyTest" inManagedObjectContext:moc_];
}

- (KMPOneToManyTestID*)objectID {
	return (KMPOneToManyTestID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic displayName;

@dynamic oneToManyId;

@dynamic topLevels;

- (NSMutableSet*)topLevelsSet {
	[self willAccessValueForKey:@"topLevels"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"topLevels"];

	[self didAccessValueForKey:@"topLevels"];
	return result;
}

@end

