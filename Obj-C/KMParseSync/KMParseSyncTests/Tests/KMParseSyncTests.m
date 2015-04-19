//
//  KMParseSyncTests.m
//  KMParseSync
//
//  Created by Keith Moon on 10/11/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

@import UIKit;
@import XCTest;
#import <KMPersistence/KMPersistence.h>

@interface KMParseSyncTests : XCTestCase

@property (nonatomic, strong) KMParseSync *syncManager;

@end

@implementation KMParseSyncTests

- (void)setUp {
    [super setUp];
    
    self.syncManager = [[KMParseSync alloc] init];
    [self.syncManager setupWithApplicationId:@"DLgbXgV2ClkiIVfgZLvz4NH9IoRwwUIlkk3X0n3s"
                                andClientKey:@"LEcj5V47HXEfUotxC4X0LDroLuBHlkxu7vrqh7FD"];
}

- (void)tearDown {
    
    self.syncManager = nil;
    
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
