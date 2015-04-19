// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KMPSingleEntityTest.m instead.

#import "_KMPSingleEntityTest.h"

const struct KMPSingleEntityTestAttributes KMPSingleEntityTestAttributes = {
	.boolProperty = @"boolProperty",
	.dataProperty = @"dataProperty",
	.dateFormatProperty = @"dateFormatProperty",
	.dateNowProperty = @"dateNowProperty",
	.decimalProperty = @"decimalProperty",
	.doubleProperty = @"doubleProperty",
	.floatProperty = @"floatProperty",
	.int16Property = @"int16Property",
	.int32Property = @"int32Property",
	.int64Property = @"int64Property",
	.stringProperty = @"stringProperty",
	.transformableProperty = @"transformableProperty",
	.uniqueProperty = @"uniqueProperty",
};

const struct KMPSingleEntityTestUserInfo KMPSingleEntityTestUserInfo = {
	.uniqueAttribute = @"uniqueProperty",
};

@implementation KMPSingleEntityTestID
@end

@implementation _KMPSingleEntityTest

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"KMPSingleEntityTest" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"KMPSingleEntityTest";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"KMPSingleEntityTest" inManagedObjectContext:moc_];
}

- (KMPSingleEntityTestID*)objectID {
	return (KMPSingleEntityTestID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"boolPropertyValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"boolProperty"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"doublePropertyValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"doubleProperty"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"floatPropertyValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"floatProperty"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"int16PropertyValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"int16Property"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"int32PropertyValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"int32Property"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"int64PropertyValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"int64Property"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic boolProperty;

- (BOOL)boolPropertyValue {
	NSNumber *result = [self boolProperty];
	return [result boolValue];
}

- (void)setBoolPropertyValue:(BOOL)value_ {
	[self setBoolProperty:@(value_)];
}

- (BOOL)primitiveBoolPropertyValue {
	NSNumber *result = [self primitiveBoolProperty];
	return [result boolValue];
}

- (void)setPrimitiveBoolPropertyValue:(BOOL)value_ {
	[self setPrimitiveBoolProperty:@(value_)];
}

@dynamic dataProperty;

@dynamic dateFormatProperty;

@dynamic dateNowProperty;

@dynamic decimalProperty;

@dynamic doubleProperty;

- (double)doublePropertyValue {
	NSNumber *result = [self doubleProperty];
	return [result doubleValue];
}

- (void)setDoublePropertyValue:(double)value_ {
	[self setDoubleProperty:@(value_)];
}

- (double)primitiveDoublePropertyValue {
	NSNumber *result = [self primitiveDoubleProperty];
	return [result doubleValue];
}

- (void)setPrimitiveDoublePropertyValue:(double)value_ {
	[self setPrimitiveDoubleProperty:@(value_)];
}

@dynamic floatProperty;

- (float)floatPropertyValue {
	NSNumber *result = [self floatProperty];
	return [result floatValue];
}

- (void)setFloatPropertyValue:(float)value_ {
	[self setFloatProperty:@(value_)];
}

- (float)primitiveFloatPropertyValue {
	NSNumber *result = [self primitiveFloatProperty];
	return [result floatValue];
}

- (void)setPrimitiveFloatPropertyValue:(float)value_ {
	[self setPrimitiveFloatProperty:@(value_)];
}

@dynamic int16Property;

- (int16_t)int16PropertyValue {
	NSNumber *result = [self int16Property];
	return [result shortValue];
}

- (void)setInt16PropertyValue:(int16_t)value_ {
	[self setInt16Property:@(value_)];
}

- (int16_t)primitiveInt16PropertyValue {
	NSNumber *result = [self primitiveInt16Property];
	return [result shortValue];
}

- (void)setPrimitiveInt16PropertyValue:(int16_t)value_ {
	[self setPrimitiveInt16Property:@(value_)];
}

@dynamic int32Property;

- (int32_t)int32PropertyValue {
	NSNumber *result = [self int32Property];
	return [result intValue];
}

- (void)setInt32PropertyValue:(int32_t)value_ {
	[self setInt32Property:@(value_)];
}

- (int32_t)primitiveInt32PropertyValue {
	NSNumber *result = [self primitiveInt32Property];
	return [result intValue];
}

- (void)setPrimitiveInt32PropertyValue:(int32_t)value_ {
	[self setPrimitiveInt32Property:@(value_)];
}

@dynamic int64Property;

- (int64_t)int64PropertyValue {
	NSNumber *result = [self int64Property];
	return [result longLongValue];
}

- (void)setInt64PropertyValue:(int64_t)value_ {
	[self setInt64Property:@(value_)];
}

- (int64_t)primitiveInt64PropertyValue {
	NSNumber *result = [self primitiveInt64Property];
	return [result longLongValue];
}

- (void)setPrimitiveInt64PropertyValue:(int64_t)value_ {
	[self setPrimitiveInt64Property:@(value_)];
}

@dynamic stringProperty;

@dynamic transformableProperty;

@dynamic uniqueProperty;

@end

