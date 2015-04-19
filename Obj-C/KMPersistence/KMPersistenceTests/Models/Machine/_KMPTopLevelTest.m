// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KMPTopLevelTest.m instead.

#import "_KMPTopLevelTest.h"

const struct KMPTopLevelTestAttributes KMPTopLevelTestAttributes = {
	.displayName = @"displayName",
	.topLevelId = @"topLevelId",
};

const struct KMPTopLevelTestRelationships KMPTopLevelTestRelationships = {
	.manyToManys = @"manyToManys",
	.manyToOnes = @"manyToOnes",
	.oneToMany = @"oneToMany",
	.oneToOne = @"oneToOne",
};

const struct KMPTopLevelTestUserInfo KMPTopLevelTestUserInfo = {
	.uniqueAttribute = @"topLevelId",
};

@implementation KMPTopLevelTestID
@end

@implementation _KMPTopLevelTest

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"KMPTopLevelTest" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"KMPTopLevelTest";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"KMPTopLevelTest" inManagedObjectContext:moc_];
}

- (KMPTopLevelTestID*)objectID {
	return (KMPTopLevelTestID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic displayName;

@dynamic topLevelId;

@dynamic manyToManys;

- (NSMutableSet*)manyToManysSet {
	[self willAccessValueForKey:@"manyToManys"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"manyToManys"];

	[self didAccessValueForKey:@"manyToManys"];
	return result;
}

@dynamic manyToOnes;

- (NSMutableSet*)manyToOnesSet {
	[self willAccessValueForKey:@"manyToOnes"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"manyToOnes"];

	[self didAccessValueForKey:@"manyToOnes"];
	return result;
}

@dynamic oneToMany;

@dynamic oneToOne;

@end

