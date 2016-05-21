//
//  NSManagedObject+Mapping.h
//  KMPersistence
//
//  Created by Keith Moon on 29/10/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

@import CoreData;

#pragma mark - User Info Keys and Values

extern const struct KMPUserInfoKey {
    __unsafe_unretained NSString *jsonKey;
    __unsafe_unretained NSString *uniqueAttribute;
    __unsafe_unretained NSString *prefixParentUnique;
    __unsafe_unretained NSString *apiPathFormat;
    __unsafe_unretained NSString *autoValue;
    __unsafe_unretained NSString *dateFormat;
} KMPUserInfoKey;

extern const struct KMPUserInfoModifier {
    __unsafe_unretained NSString *hash;
} KMPUserInfoModifier;

extern const struct KMPUserInfoAutoValue {
    __unsafe_unretained NSString *now;
} KMPUserInfoAutoValue;

@interface NSManagedObject (KMPMapping)

- (BOOL)mapResponseDictionary:(NSDictionary *)responseDictionary withError:(NSError *__autoreleasing*)error;

@end
