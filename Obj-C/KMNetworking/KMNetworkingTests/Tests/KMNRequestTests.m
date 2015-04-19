//
//  KMNRequestTests.m
//  KMNetworking
//
//  Created by Keith Moon on 31/10/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

@import UIKit;
@import XCTest;
#import <KMNetworking/KMNetworking.h>

@interface KMNetworking (TestHelper) <NSURLSessionDelegate>

@end

@interface KMNRequestTests : XCTestCase

@property (nonatomic, strong) NSBundle *testBundle;
@property (nonatomic, strong) KMNetworking *requestManager;

@end

@implementation KMNRequestTests

- (void)setUp {
    [super setUp];
    
    self.testBundle = [NSBundle bundleForClass:self.class];
    self.requestManager = [KMNetworking sharedManager];
    
    NSURLSessionConfiguration *testConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    testConfig.protocolClasses = @[[KMNStaticDataTestingProtocol class]];
    NSURLSession *testSession = [NSURLSession sessionWithConfiguration:testConfig
                                                              delegate:self.requestManager
                                                         delegateQueue:self.requestManager.networkQueue];
    self.requestManager.networkSession = testSession;
}

- (void)tearDown {
    
    self.testBundle = nil;
    self.requestManager = nil;
    [KMNStaticDataTestingProtocol clearStaticData];
    
    [super tearDown];
}

// Do we need to be able to cancel the request?

- (void)testRequestForNetworkResourceReturnsSuccessfully {
    
    NSURL *url = [NSURL URLWithString:@"http://www.keefmoon.com/RelationshipTest"];
    
    NSHTTPURLResponse *staticDataResponse = [[NSHTTPURLResponse alloc] initWithURL:url
                                                                        statusCode:KMNResponseStatusCodeOK
                                                                       HTTPVersion:KMNResponseHeaderHTTPVersion.http1_1
                                                                      headerFields:@{KMNResponseHeaderKey.contentType: KMNResponseContentType.html}];
    
    NSURL *responseDataURL = [self.testBundle URLForResource:@"RelationshipTest" withExtension:@"json"];
    NSData *responseData = [NSData dataWithContentsOfURL:responseDataURL];
    
    [KMNStaticDataTestingProtocol setResponse:staticDataResponse forURL:url];
    [KMNStaticDataTestingProtocol setData:responseData forURL:url];
    
    XCTestExpectation *completionHandlerFiresExpectation = [self expectationWithDescription:@"Completion Handler Fired"];
    
    
    [self.requestManager enqueueRequestForURL:url withBackgroundCompletionHandler:^(BOOL successful, NSURLResponse *response, id responseObject, NSError *error) {
        
        XCTAssertTrue(successful, @"A successful request should pass YES to the success Bool in the completionHandler: Expected: %@. Actual: %@", @(YES), @(successful));
        XCTAssertNil(error, @"A successful request should pass nil for the error in the completionHandler: Actual: %@", error.description);
        XCTAssertNotNil(response, @"A successful request should pass the URL response object to the completionHandler");
        XCTAssertNotNil(responseObject, @"A successful request should pass the response object to the completionHandler");
        
        [completionHandlerFiresExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:3 handler:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)testRequestForJSONResourceReturnsDictionaryWithResults {
    
    NSURL *url = [NSURL URLWithString:@"http://www.keefmoon.com/RelationshipTest"];
    
    NSHTTPURLResponse *staticDataResponse = [[NSHTTPURLResponse alloc] initWithURL:url
                                                                        statusCode:KMNResponseStatusCodeOK
                                                                       HTTPVersion:KMNResponseHeaderHTTPVersion.http1_1
                                                                      headerFields:@{KMNResponseHeaderKey.contentType: KMNResponseContentType.json}];
    
    NSURL *responseDataURL = [self.testBundle URLForResource:@"RelationshipTest" withExtension:@"json"];
    NSData *responseData = [NSData dataWithContentsOfURL:responseDataURL];
    
    [KMNStaticDataTestingProtocol setResponse:staticDataResponse forURL:url];
    [KMNStaticDataTestingProtocol setData:responseData forURL:url];
    
    XCTestExpectation *completionHandlerFiresExpectation = [self expectationWithDescription:@"Completion Handler Fired"];
    
    [self.requestManager enqueueRequestForURL:url withBackgroundCompletionHandler:^(BOOL successful, NSURLResponse *response, id responseObject, NSError *error) {
        
        XCTAssertTrue([responseObject isKindOfClass:[NSDictionary class]], @"A successful JSON request should pass the parsed response object to the completionHandler: Expected: %@. Actual: %@", NSStringFromClass([NSDictionary class]), responseObject);
        
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSArray *resultsArray = responseDictionary[@"results"];
        XCTAssertNotNil(resultsArray, @"A successul JSON resonse should have a dictionary that has a results key in it. Actual: %@", resultsArray);
        XCTAssertTrue([resultsArray isKindOfClass:[NSArray class]], @"A successful JSON response should have an array at the results key. Actual: %@", resultsArray);
        
        [completionHandlerFiresExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:3 handler:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)testRequestForResourceNotFoundShouldReturnAnError {
    
    NSURL *url = [NSURL URLWithString:@"http://www.keefmoon.com/NotFound"];
    
    NSHTTPURLResponse *staticDataResponse = [[NSHTTPURLResponse alloc] initWithURL:url
                                                                        statusCode:KMNResponseStatusCodeResourceNotFound
                                                                       HTTPVersion:KMNResponseHeaderHTTPVersion.http1_1
                                                                      headerFields:@{KMNResponseHeaderKey.contentType: KMNResponseContentType.html}];
    [KMNStaticDataTestingProtocol setResponse:staticDataResponse forURL:url];
    
    XCTestExpectation *completionHandlerFiresExpectation = [self expectationWithDescription:@"Completion Handler Fired"];
    
    [self.requestManager enqueueRequestForURL:url withBackgroundCompletionHandler:^(BOOL successful, NSURLResponse *response, id responseObject, NSError *error) {
        
        XCTAssertFalse(successful, @"A request for a non-existent resource should pass NO to the success Bool in the completionHandler: Expected: %@. Actual: %@", @(NO), @(successful));
        XCTAssertNotNil(error, @"A request for a non-existent resource should pass an error in the completionHandler");
        XCTAssertNotNil(response, @"A request for a non-existent resource should pass the URL response object to the completionHandler");
        XCTAssertNotNil(responseObject, @"A request for a non-existent resource should still pass any response data as the response object to the completionHandler");
        
        XCTAssertTrue([error.domain isEqualToString:KMNErrorDomain], @"A request for a non-existent resource should pass an error with the correct domain in the completionHandler. Expected: %@ Actual: %@", KMNErrorDomain, error.domain);
        XCTAssertTrue(error.code == KMNErrorCodeUnexpectedResponseCode, @"A request for a non-existent resource should pass an error with the correct code in the completionHandler. Expected: %@ Actual: %@", @(KMNErrorCodeUnexpectedResponseCode), @(error.code));
        
        [completionHandlerFiresExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:3 handler:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)testRequestForUnparsableJSONReturnsError {
    
    NSURL *url = [NSURL URLWithString:@"http://www.keefmoon.com/BadJSON"];
    
    NSHTTPURLResponse *staticDataResponse = [[NSHTTPURLResponse alloc] initWithURL:url
                                                                        statusCode:KMNResponseStatusCodeOK
                                                                       HTTPVersion:KMNResponseHeaderHTTPVersion.http1_1
                                                                      headerFields:@{KMNResponseHeaderKey.contentType: KMNResponseContentType.json}];
    NSData *responseData = [@"Bad bad bad JSON. This is not JSON" dataUsingEncoding:NSUTF8StringEncoding];
    
    [KMNStaticDataTestingProtocol setResponse:staticDataResponse forURL:url];
    [KMNStaticDataTestingProtocol setData:responseData forURL:url];
    
    XCTestExpectation *completionHandlerFiresExpectation = [self expectationWithDescription:@"Completion Handler Fired"];
    
    [self.requestManager enqueueRequestForURL:url withBackgroundCompletionHandler:^(BOOL successful, NSURLResponse *response, id responseObject, NSError *error) {
        
        XCTAssertFalse(successful, @"A JSON request that can't be parsed should pass NO to the success Bool in the completionHandler: Expected: %@. Actual: %@", @(NO), @(successful));
        XCTAssertNotNil(error, @"A JSON request that can't be parsed should pass an error in the completionHandler");
        XCTAssertNotNil(response, @"A JSON request that can't be parsed should pass the URL response object to the completionHandler");
        XCTAssertNil(responseObject, @"A JSON request that can't be parsed should pass nil as the response object to the completionHandler. Actual: %@", responseObject);
        
        [completionHandlerFiresExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:3 handler:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)testRequestCompletionHandlerIsPrcocessOnBackgroundThread {
    
    NSURL *url = [NSURL URLWithString:@"http://www.keefmoon.com/BadJSON"];
    
    NSHTTPURLResponse *staticDataResponse = [[NSHTTPURLResponse alloc] initWithURL:url
                                                                        statusCode:KMNResponseStatusCodeOK
                                                                       HTTPVersion:KMNResponseHeaderHTTPVersion.http1_1
                                                                      headerFields:@{KMNResponseHeaderKey.contentType: KMNResponseContentType.json}];
    NSURL *responseDataURL = [self.testBundle URLForResource:@"RelationshipTest" withExtension:@"json"];
    NSData *responseData = [NSData dataWithContentsOfURL:responseDataURL];
    
    [KMNStaticDataTestingProtocol setResponse:staticDataResponse forURL:url];
    [KMNStaticDataTestingProtocol setData:responseData forURL:url];
    
    XCTestExpectation *completionHandlerFiresExpectation = [self expectationWithDescription:@"Completion Handler Fired"];
    
    [self.requestManager enqueueRequestForURL:url withBackgroundCompletionHandler:^(BOOL successful, NSURLResponse *response, id responseObject, NSError *error) {
        
        XCTAssertFalse([NSThread isMainThread], @"The baground completion handler should not be processed on the main thread");
        
        [completionHandlerFiresExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:3 handler:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
