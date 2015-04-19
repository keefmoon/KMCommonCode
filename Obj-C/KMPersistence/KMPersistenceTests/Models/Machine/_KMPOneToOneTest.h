// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KMPOneToOneTest.h instead.

@import CoreData;

extern const struct KMPOneToOneTestAttributes {
	__unsafe_unretained NSString *displayName;
	__unsafe_unretained NSString *oneToOneId;
} KMPOneToOneTestAttributes;

extern const struct KMPOneToOneTestRelationships {
	__unsafe_unretained NSString *secondLevel;
	__unsafe_unretained NSString *topLevel;
} KMPOneToOneTestRelationships;

extern const struct KMPOneToOneTestUserInfo {
	__unsafe_unretained NSString *uniqueAttribute;
} KMPOneToOneTestUserInfo;

@class KMPSecondLevelDeepTest;
@class KMPTopLevelTest;

@interface KMPOneToOneTestID : NSManagedObjectID {}
@end

@interface _KMPOneToOneTest : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) KMPOneToOneTestID* objectID;

@property (nonatomic, strong) NSString* displayName;

//- (BOOL)validateDisplayName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* oneToOneId;

//- (BOOL)validateOneToOneId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) KMPSecondLevelDeepTest *secondLevel;

//- (BOOL)validateSecondLevel:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) KMPTopLevelTest *topLevel;

//- (BOOL)validateTopLevel:(id*)value_ error:(NSError**)error_;

@end

@interface _KMPOneToOneTest (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveDisplayName;
- (void)setPrimitiveDisplayName:(NSString*)value;

- (NSString*)primitiveOneToOneId;
- (void)setPrimitiveOneToOneId:(NSString*)value;

- (KMPSecondLevelDeepTest*)primitiveSecondLevel;
- (void)setPrimitiveSecondLevel:(KMPSecondLevelDeepTest*)value;

- (KMPTopLevelTest*)primitiveTopLevel;
- (void)setPrimitiveTopLevel:(KMPTopLevelTest*)value;

@end
