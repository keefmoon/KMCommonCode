// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KMPSecondLevelDeepTest.m instead.

#import "_KMPSecondLevelDeepTest.h"

const struct KMPSecondLevelDeepTestAttributes KMPSecondLevelDeepTestAttributes = {
	.displayName = @"displayName",
	.secondLevelDeepId = @"secondLevelDeepId",
};

const struct KMPSecondLevelDeepTestRelationships KMPSecondLevelDeepTestRelationships = {
	.oneToOne = @"oneToOne",
};

const struct KMPSecondLevelDeepTestUserInfo KMPSecondLevelDeepTestUserInfo = {
	.uniqueAttribute = @"secondLevelDeepId",
};

@implementation KMPSecondLevelDeepTestID
@end

@implementation _KMPSecondLevelDeepTest

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"KMPSecondLevelDeepTest" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"KMPSecondLevelDeepTest";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"KMPSecondLevelDeepTest" inManagedObjectContext:moc_];
}

- (KMPSecondLevelDeepTestID*)objectID {
	return (KMPSecondLevelDeepTestID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic displayName;

@dynamic secondLevelDeepId;

@dynamic oneToOne;

@end

