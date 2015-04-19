// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KMPSingleEntityTest.h instead.

@import CoreData;

extern const struct KMPSingleEntityTestAttributes {
	__unsafe_unretained NSString *boolProperty;
	__unsafe_unretained NSString *dataProperty;
	__unsafe_unretained NSString *dateFormatProperty;
	__unsafe_unretained NSString *dateNowProperty;
	__unsafe_unretained NSString *decimalProperty;
	__unsafe_unretained NSString *doubleProperty;
	__unsafe_unretained NSString *floatProperty;
	__unsafe_unretained NSString *int16Property;
	__unsafe_unretained NSString *int32Property;
	__unsafe_unretained NSString *int64Property;
	__unsafe_unretained NSString *stringProperty;
	__unsafe_unretained NSString *transformableProperty;
	__unsafe_unretained NSString *uniqueProperty;
} KMPSingleEntityTestAttributes;

extern const struct KMPSingleEntityTestUserInfo {
	__unsafe_unretained NSString *uniqueAttribute;
} KMPSingleEntityTestUserInfo;

@class NSObject;

@interface KMPSingleEntityTestID : NSManagedObjectID {}
@end

@interface _KMPSingleEntityTest : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) KMPSingleEntityTestID* objectID;

@property (nonatomic, strong) NSNumber* boolProperty;

@property (atomic) BOOL boolPropertyValue;
- (BOOL)boolPropertyValue;
- (void)setBoolPropertyValue:(BOOL)value_;

//- (BOOL)validateBoolProperty:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSData* dataProperty;

//- (BOOL)validateDataProperty:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* dateFormatProperty;

//- (BOOL)validateDateFormatProperty:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* dateNowProperty;

//- (BOOL)validateDateNowProperty:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDecimalNumber* decimalProperty;

//- (BOOL)validateDecimalProperty:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* doubleProperty;

@property (atomic) double doublePropertyValue;
- (double)doublePropertyValue;
- (void)setDoublePropertyValue:(double)value_;

//- (BOOL)validateDoubleProperty:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* floatProperty;

@property (atomic) float floatPropertyValue;
- (float)floatPropertyValue;
- (void)setFloatPropertyValue:(float)value_;

//- (BOOL)validateFloatProperty:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* int16Property;

@property (atomic) int16_t int16PropertyValue;
- (int16_t)int16PropertyValue;
- (void)setInt16PropertyValue:(int16_t)value_;

//- (BOOL)validateInt16Property:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* int32Property;

@property (atomic) int32_t int32PropertyValue;
- (int32_t)int32PropertyValue;
- (void)setInt32PropertyValue:(int32_t)value_;

//- (BOOL)validateInt32Property:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* int64Property;

@property (atomic) int64_t int64PropertyValue;
- (int64_t)int64PropertyValue;
- (void)setInt64PropertyValue:(int64_t)value_;

//- (BOOL)validateInt64Property:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* stringProperty;

//- (BOOL)validateStringProperty:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) id transformableProperty;

//- (BOOL)validateTransformableProperty:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* uniqueProperty;

//- (BOOL)validateUniqueProperty:(id*)value_ error:(NSError**)error_;

@end

@interface _KMPSingleEntityTest (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveBoolProperty;
- (void)setPrimitiveBoolProperty:(NSNumber*)value;

- (BOOL)primitiveBoolPropertyValue;
- (void)setPrimitiveBoolPropertyValue:(BOOL)value_;

- (NSData*)primitiveDataProperty;
- (void)setPrimitiveDataProperty:(NSData*)value;

- (NSDate*)primitiveDateFormatProperty;
- (void)setPrimitiveDateFormatProperty:(NSDate*)value;

- (NSDate*)primitiveDateNowProperty;
- (void)setPrimitiveDateNowProperty:(NSDate*)value;

- (NSDecimalNumber*)primitiveDecimalProperty;
- (void)setPrimitiveDecimalProperty:(NSDecimalNumber*)value;

- (NSNumber*)primitiveDoubleProperty;
- (void)setPrimitiveDoubleProperty:(NSNumber*)value;

- (double)primitiveDoublePropertyValue;
- (void)setPrimitiveDoublePropertyValue:(double)value_;

- (NSNumber*)primitiveFloatProperty;
- (void)setPrimitiveFloatProperty:(NSNumber*)value;

- (float)primitiveFloatPropertyValue;
- (void)setPrimitiveFloatPropertyValue:(float)value_;

- (NSNumber*)primitiveInt16Property;
- (void)setPrimitiveInt16Property:(NSNumber*)value;

- (int16_t)primitiveInt16PropertyValue;
- (void)setPrimitiveInt16PropertyValue:(int16_t)value_;

- (NSNumber*)primitiveInt32Property;
- (void)setPrimitiveInt32Property:(NSNumber*)value;

- (int32_t)primitiveInt32PropertyValue;
- (void)setPrimitiveInt32PropertyValue:(int32_t)value_;

- (NSNumber*)primitiveInt64Property;
- (void)setPrimitiveInt64Property:(NSNumber*)value;

- (int64_t)primitiveInt64PropertyValue;
- (void)setPrimitiveInt64PropertyValue:(int64_t)value_;

- (NSString*)primitiveStringProperty;
- (void)setPrimitiveStringProperty:(NSString*)value;

- (id)primitiveTransformableProperty;
- (void)setPrimitiveTransformableProperty:(id)value;

- (NSString*)primitiveUniqueProperty;
- (void)setPrimitiveUniqueProperty:(NSString*)value;

@end
