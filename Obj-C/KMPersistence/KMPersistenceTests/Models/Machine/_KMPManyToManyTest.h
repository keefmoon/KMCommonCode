// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KMPManyToManyTest.h instead.

@import CoreData;

extern const struct KMPManyToManyTestAttributes {
	__unsafe_unretained NSString *displayName;
	__unsafe_unretained NSString *manyToManyId;
} KMPManyToManyTestAttributes;

extern const struct KMPManyToManyTestRelationships {
	__unsafe_unretained NSString *topLevels;
} KMPManyToManyTestRelationships;

extern const struct KMPManyToManyTestUserInfo {
	__unsafe_unretained NSString *uniqueAttribute;
} KMPManyToManyTestUserInfo;

@class KMPTopLevelTest;

@interface KMPManyToManyTestID : NSManagedObjectID {}
@end

@interface _KMPManyToManyTest : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) KMPManyToManyTestID* objectID;

@property (nonatomic, strong) NSString* displayName;

//- (BOOL)validateDisplayName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* manyToManyId;

//- (BOOL)validateManyToManyId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *topLevels;

- (NSMutableSet*)topLevelsSet;

@end

@interface _KMPManyToManyTest (TopLevelsCoreDataGeneratedAccessors)
- (void)addTopLevels:(NSSet*)value_;
- (void)removeTopLevels:(NSSet*)value_;
- (void)addTopLevelsObject:(KMPTopLevelTest*)value_;
- (void)removeTopLevelsObject:(KMPTopLevelTest*)value_;
@end

@interface _KMPManyToManyTest (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveDisplayName;
- (void)setPrimitiveDisplayName:(NSString*)value;

- (NSString*)primitiveManyToManyId;
- (void)setPrimitiveManyToManyId:(NSString*)value;

- (NSMutableSet*)primitiveTopLevels;
- (void)setPrimitiveTopLevels:(NSMutableSet*)value;

@end
