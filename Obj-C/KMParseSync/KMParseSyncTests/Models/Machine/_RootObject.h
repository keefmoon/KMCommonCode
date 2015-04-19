// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RootObject.h instead.

@import CoreData;

extern const struct RootObjectAttributes {
	__unsafe_unretained NSString *remoteId;
} RootObjectAttributes;

extern const struct RootObjectUserInfo {
	__unsafe_unretained NSString *parseClass;
} RootObjectUserInfo;

@interface RootObjectID : NSManagedObjectID {}
@end

@interface _RootObject : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RootObjectID* objectID;

@property (nonatomic, strong) NSString* remoteId;

//- (BOOL)validateRemoteId:(id*)value_ error:(NSError**)error_;

@end

@interface _RootObject (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveRemoteId;
- (void)setPrimitiveRemoteId:(NSString*)value;

@end
