//
//  KMNResponseDefines.h
//  KMNetworking
//
//  Created by Keith Moon on 04/11/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

@import Foundation;

typedef enum : NSUInteger {
    KMNResponseStatusCodeOK = 200,
    KMNResponseStatusCodeResourceNotFound = 404,
    KMNResponseStatusCodeNotModified = 403,
    KMNResponseStatusCodeServerError = 500
} KMNResponseStatusCode;

extern const struct KMNResponseHeaderHTTPVersion {
    __unsafe_unretained NSString *http1_1;
} KMNResponseHeaderHTTPVersion;

extern const struct KMNResponseHeaderKey {
    __unsafe_unretained NSString *cacheControl;
    __unsafe_unretained NSString *contentType;
} KMNResponseHeaderKey;

extern const struct KMNResponseContentType {
    __unsafe_unretained NSString *json;
    __unsafe_unretained NSString *html;
} KMNResponseContentType;
