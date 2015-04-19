// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RootObject.m instead.

#import "_RootObject.h"

const struct RootObjectAttributes RootObjectAttributes = {
	.remoteId = @"remoteId",
};

const struct RootObjectUserInfo RootObjectUserInfo = {
	.parseClass = @"RootObject",
};

@implementation RootObjectID
@end

@implementation _RootObject

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RootObject" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RootObject";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RootObject" inManagedObjectContext:moc_];
}

- (RootObjectID*)objectID {
	return (RootObjectID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic remoteId;

@end

