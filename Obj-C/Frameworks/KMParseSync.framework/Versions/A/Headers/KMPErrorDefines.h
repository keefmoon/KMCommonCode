//
//  TPErrorDefines.h
//  KMPersistence
//
//  Created by Keith Moon on 29/10/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

#pragma mark - Error defines

enum KMPErrorCode {
    KMPErrorCodeUnknownError, /**< If no expected error is generated during retrieval but the asset is still nil  */
    KMPErrorCodeIncorrectMappingValue,
    KMPErrorCodeUnableToMapNilDictionary,
    KMPErrorCodeCombinedError,
    KMPErrorCodeCoreDataSetup,
    KMPErrorCodeUnsupportedMappingObjectType,
    KMPErrorCodeNoUniqueAttribute
};

static NSString *const KMPErrorDomain = @"com.travelex.persistence.error";

static NSString *const KMPErrorUserInfoKeyErrors = @"KMPErrorUserInfoKeyErrors";
static NSString *const KMPErrorUserInfoKeyMappingKey = @"KMPErrorUserInfoKeyMappingKey";
static NSString *const KMPErrorUserInfoKeyMappingValue = @"KMPErrorUserInfoKeyMappingValue";
static NSString *const KMPErrorUserInfoKeyUnsupportedMappingObject = @"KMPErrorUserInfoKeyUnsupportedMappingObject";
static NSString *const KMPErrorUserInfoKeyEntity = @"KMPErrorUserInfoKeyEntity";
