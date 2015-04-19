// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KMPManyToOneTest.h instead.

@import CoreData;

extern const struct KMPManyToOneTestAttributes {
	__unsafe_unretained NSString *displayName;
	__unsafe_unretained NSString *manyToOneId;
} KMPManyToOneTestAttributes;

extern const struct KMPManyToOneTestRelationships {
	__unsafe_unretained NSString *topLevel;
} KMPManyToOneTestRelationships;

extern const struct KMPManyToOneTestUserInfo {
	__unsafe_unretained NSString *uniqueAttribute;
} KMPManyToOneTestUserInfo;

@class KMPTopLevelTest;

@interface KMPManyToOneTestID : NSManagedObjectID {}
@end

@interface _KMPManyToOneTest : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) KMPManyToOneTestID* objectID;

@property (nonatomic, strong) NSString* displayName;

//- (BOOL)validateDisplayName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* manyToOneId;

//- (BOOL)validateManyToOneId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) KMPTopLevelTest *topLevel;

//- (BOOL)validateTopLevel:(id*)value_ error:(NSError**)error_;

@end

@interface _KMPManyToOneTest (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveDisplayName;
- (void)setPrimitiveDisplayName:(NSString*)value;

- (NSString*)primitiveManyToOneId;
- (void)setPrimitiveManyToOneId:(NSString*)value;

- (KMPTopLevelTest*)primitiveTopLevel;
- (void)setPrimitiveTopLevel:(KMPTopLevelTest*)value;

@end
