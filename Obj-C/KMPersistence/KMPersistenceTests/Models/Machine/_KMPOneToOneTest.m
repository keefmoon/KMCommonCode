// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KMPOneToOneTest.m instead.

#import "_KMPOneToOneTest.h"

const struct KMPOneToOneTestAttributes KMPOneToOneTestAttributes = {
	.displayName = @"displayName",
	.oneToOneId = @"oneToOneId",
};

const struct KMPOneToOneTestRelationships KMPOneToOneTestRelationships = {
	.secondLevel = @"secondLevel",
	.topLevel = @"topLevel",
};

const struct KMPOneToOneTestUserInfo KMPOneToOneTestUserInfo = {
	.uniqueAttribute = @"oneToOneId",
};

@implementation KMPOneToOneTestID
@end

@implementation _KMPOneToOneTest

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"KMPOneToOneTest" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"KMPOneToOneTest";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"KMPOneToOneTest" inManagedObjectContext:moc_];
}

- (KMPOneToOneTestID*)objectID {
	return (KMPOneToOneTestID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic displayName;

@dynamic oneToOneId;

@dynamic secondLevel;

@dynamic topLevel;

@end

