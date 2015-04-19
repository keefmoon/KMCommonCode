//
//  KMNResponseDefines.m
//  KMNetworking
//
//  Created by Keith Moon on 04/11/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

#import "KMNResponseDefines.h"

const struct KMNResponseHeaderHTTPVersion KMNResponseHeaderHTTPVersion = {
    .http1_1 = @"HTTP/1.1",
};

const struct KMNResponseHeaderKey KMNResponseHeaderKey = {
    .cacheControl = @"Cache-Control",
    .contentType = @"Content-Type",
};

const struct KMNResponseContentType KMNResponseContentType = {
    .json = @"application/json",
    .html = @"text/html",
};