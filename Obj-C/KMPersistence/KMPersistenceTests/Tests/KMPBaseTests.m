//
//  KMPBaseTests.m
//  KMPersistence
//
//  Created by Keith Moon on 31/10/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

#import "KMPBaseTests.h"

@implementation KMPBaseTests

- (void)setUp {
    [super setUp];
    
    self.testBundle = [NSBundle bundleForClass:self.class];
}

- (void)tearDown {
    
    self.testBundle = nil;
    
    [super tearDown];
}

#pragma mark - Helper Methods

- (BOOL)testNumber:(NSNumber *)firstNumber isWithinToleranceOfBeingEqualToNumber:(NSNumber *)secondNumber {
    return (abs([firstNumber doubleValue] - [secondNumber doubleValue]) < 1.0e-7);
}

- (NSDictionary *)parseJSONWithFileName:(NSString *)filename {
    
    NSURL *jsonURL = [self.testBundle URLForResource:filename withExtension:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
    NSError *parsingError;
    NSDictionary *parsedDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&parsingError];
    if (parsingError) {
        NSLog(@"Parsing Error: %@", parsingError);
    }
    
    return parsedDictionary;
}

- (NSArray *)resultsArrayFromDictionary:(NSDictionary *)dictionary {
    return dictionary[@"results"];
}

@end
