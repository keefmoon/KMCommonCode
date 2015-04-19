//
//  KMNErrorDefines.h
//  KMNetworking
//
//  Created by Keith Moon on 03/11/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

#pragma mark - Error defines

enum KMNErrorCode {
    KMNErrorCodeUnknownError, /**< If no expected error is generated during retrieval but the asset is still nil  */
    KMNErrorCodeUnexpectedResponseCode
};

static NSString *const KMNErrorDomain = @"com.travelex.networking.error";