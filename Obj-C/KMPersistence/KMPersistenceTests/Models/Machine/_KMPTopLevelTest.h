// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KMPTopLevelTest.h instead.

@import CoreData;

extern const struct KMPTopLevelTestAttributes {
	__unsafe_unretained NSString *displayName;
	__unsafe_unretained NSString *topLevelId;
} KMPTopLevelTestAttributes;

extern const struct KMPTopLevelTestRelationships {
	__unsafe_unretained NSString *manyToManys;
	__unsafe_unretained NSString *manyToOnes;
	__unsafe_unretained NSString *oneToMany;
	__unsafe_unretained NSString *oneToOne;
} KMPTopLevelTestRelationships;

extern const struct KMPTopLevelTestUserInfo {
	__unsafe_unretained NSString *uniqueAttribute;
} KMPTopLevelTestUserInfo;

@class KMPManyToManyTest;
@class KMPManyToOneTest;
@class KMPOneToManyTest;
@class KMPOneToOneTest;

@interface KMPTopLevelTestID : NSManagedObjectID {}
@end

@interface _KMPTopLevelTest : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) KMPTopLevelTestID* objectID;

@property (nonatomic, strong) NSString* displayName;

//- (BOOL)validateDisplayName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* topLevelId;

//- (BOOL)validateTopLevelId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *manyToManys;

- (NSMutableSet*)manyToManysSet;

@property (nonatomic, strong) NSSet *manyToOnes;

- (NSMutableSet*)manyToOnesSet;

@property (nonatomic, strong) KMPOneToManyTest *oneToMany;

//- (BOOL)validateOneToMany:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) KMPOneToOneTest *oneToOne;

//- (BOOL)validateOneToOne:(id*)value_ error:(NSError**)error_;

@end

@interface _KMPTopLevelTest (ManyToManysCoreDataGeneratedAccessors)
- (void)addManyToManys:(NSSet*)value_;
- (void)removeManyToManys:(NSSet*)value_;
- (void)addManyToManysObject:(KMPManyToManyTest*)value_;
- (void)removeManyToManysObject:(KMPManyToManyTest*)value_;
@end

@interface _KMPTopLevelTest (ManyToOnesCoreDataGeneratedAccessors)
- (void)addManyToOnes:(NSSet*)value_;
- (void)removeManyToOnes:(NSSet*)value_;
- (void)addManyToOnesObject:(KMPManyToOneTest*)value_;
- (void)removeManyToOnesObject:(KMPManyToOneTest*)value_;
@end

@interface _KMPTopLevelTest (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveDisplayName;
- (void)setPrimitiveDisplayName:(NSString*)value;

- (NSString*)primitiveTopLevelId;
- (void)setPrimitiveTopLevelId:(NSString*)value;

- (NSMutableSet*)primitiveManyToManys;
- (void)setPrimitiveManyToManys:(NSMutableSet*)value;

- (NSMutableSet*)primitiveManyToOnes;
- (void)setPrimitiveManyToOnes:(NSMutableSet*)value;

- (KMPOneToManyTest*)primitiveOneToMany;
- (void)setPrimitiveOneToMany:(KMPOneToManyTest*)value;

- (KMPOneToOneTest*)primitiveOneToOne;
- (void)setPrimitiveOneToOne:(KMPOneToOneTest*)value;

@end
