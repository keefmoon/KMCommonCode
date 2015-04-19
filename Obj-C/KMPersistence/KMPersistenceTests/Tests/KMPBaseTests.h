//
//  KMPBaseTests.h
//  KMPersistence
//
//  Created by Keith Moon on 31/10/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

@import UIKit;
@import XCTest;

@interface KMPBaseTests : XCTestCase

@property (nonatomic, strong) NSBundle *testBundle;

- (BOOL)testNumber:(NSNumber *)firstNumber isWithinToleranceOfBeingEqualToNumber:(NSNumber *)secondNumber;
- (NSDictionary *)parseJSONWithFileName:(NSString *)filename;
- (NSArray *)resultsArrayFromDictionary:(NSDictionary *)dictionary;

@end
