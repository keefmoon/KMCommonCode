//
//  KMNStaticDataTestingProtocol.h
//  KMNNetworking
//
//  Created by Keith Moon on 12/07/2013.
//  Copyright (c) 2013 Keith Moon. All rights reserved.
//

@import Foundation;

@interface KMNStaticDataTestingProtocol : NSURLProtocol

+ (void)setResponse:(NSURLResponse *)response forURL:(NSURL *)url;
+ (void)setData:(NSData *)data forURL:(NSURL *)url;
+ (void)clearStaticData;

@end
