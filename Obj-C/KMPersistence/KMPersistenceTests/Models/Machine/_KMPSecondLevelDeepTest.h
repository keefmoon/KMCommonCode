// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KMPSecondLevelDeepTest.h instead.

@import CoreData;

extern const struct KMPSecondLevelDeepTestAttributes {
	__unsafe_unretained NSString *displayName;
	__unsafe_unretained NSString *secondLevelDeepId;
} KMPSecondLevelDeepTestAttributes;

extern const struct KMPSecondLevelDeepTestRelationships {
	__unsafe_unretained NSString *oneToOne;
} KMPSecondLevelDeepTestRelationships;

extern const struct KMPSecondLevelDeepTestUserInfo {
	__unsafe_unretained NSString *uniqueAttribute;
} KMPSecondLevelDeepTestUserInfo;

@class KMPOneToOneTest;

@interface KMPSecondLevelDeepTestID : NSManagedObjectID {}
@end

@interface _KMPSecondLevelDeepTest : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) KMPSecondLevelDeepTestID* objectID;

@property (nonatomic, strong) NSString* displayName;

//- (BOOL)validateDisplayName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* secondLevelDeepId;

//- (BOOL)validateSecondLevelDeepId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) KMPOneToOneTest *oneToOne;

//- (BOOL)validateOneToOne:(id*)value_ error:(NSError**)error_;

@end

@interface _KMPSecondLevelDeepTest (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveDisplayName;
- (void)setPrimitiveDisplayName:(NSString*)value;

- (NSString*)primitiveSecondLevelDeepId;
- (void)setPrimitiveSecondLevelDeepId:(NSString*)value;

- (KMPOneToOneTest*)primitiveOneToOne;
- (void)setPrimitiveOneToOne:(KMPOneToOneTest*)value;

@end
