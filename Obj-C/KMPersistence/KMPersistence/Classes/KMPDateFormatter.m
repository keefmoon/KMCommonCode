//
//  KMPDateFormatter.m
//  KMPersistence
//
//  Created by Keith Moon on 28/10/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

#import "KMPDateFormatter.h"

@implementation KMPDateFormatter

+ (instancetype)sharedFormatter {
    static KMPDateFormatter *sharedInstance;
    static dispatch_once_t done;
    
    dispatch_once(&done, ^{
        sharedInstance = [[KMPDateFormatter alloc] init];
    });
    return sharedInstance;
}

@end
