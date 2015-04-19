// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KMPOneToManyTest.h instead.

@import CoreData;

extern const struct KMPOneToManyTestAttributes {
	__unsafe_unretained NSString *displayName;
	__unsafe_unretained NSString *oneToManyId;
} KMPOneToManyTestAttributes;

extern const struct KMPOneToManyTestRelationships {
	__unsafe_unretained NSString *topLevels;
} KMPOneToManyTestRelationships;

extern const struct KMPOneToManyTestUserInfo {
	__unsafe_unretained NSString *uniqueAttribute;
} KMPOneToManyTestUserInfo;

@class KMPTopLevelTest;

@interface KMPOneToManyTestID : NSManagedObjectID {}
@end

@interface _KMPOneToManyTest : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) KMPOneToManyTestID* objectID;

@property (nonatomic, strong) NSString* displayName;

//- (BOOL)validateDisplayName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* oneToManyId;

//- (BOOL)validateOneToManyId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *topLevels;

- (NSMutableSet*)topLevelsSet;

@end

@interface _KMPOneToManyTest (TopLevelsCoreDataGeneratedAccessors)
- (void)addTopLevels:(NSSet*)value_;
- (void)removeTopLevels:(NSSet*)value_;
- (void)addTopLevelsObject:(KMPTopLevelTest*)value_;
- (void)removeTopLevelsObject:(KMPTopLevelTest*)value_;
@end

@interface _KMPOneToManyTest (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveDisplayName;
- (void)setPrimitiveDisplayName:(NSString*)value;

- (NSString*)primitiveOneToManyId;
- (void)setPrimitiveOneToManyId:(NSString*)value;

- (NSMutableSet*)primitiveTopLevels;
- (void)setPrimitiveTopLevels:(NSMutableSet*)value;

@end
