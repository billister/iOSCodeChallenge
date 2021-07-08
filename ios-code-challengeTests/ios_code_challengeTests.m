//
//  ios_code_challengeTests.m
//  ios-code-challengeTests
//
//  Created by Dustin Lange on 1/20/18.
//  Copyright © 2018 Dustin Lange. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YLPBusiness.h"

@interface ios_code_challengeTests : XCTestCase

@end

@implementation ios_code_challengeTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testYLPBusinessModel {
    // This is an example of a functional test case.
    NSDictionary *category1 = @{@"alias": @"bars", @"title": @"Bars"};
    NSDictionary *category2 = @{@"alias": @"mexican", @"title": @"Mexican"};
    NSArray *categoryArray = @[category1, category2];
    
    NSDictionary *businessDictionary = @{@"name": @"Besito Mexican Restaurant",
                                         @"categories": categoryArray,
                                         @"distance": @1212.6183881558743};
    YLPBusiness *dataModel = [[YLPBusiness alloc] initWithAttributes:businessDictionary];
    
    XCTAssert([dataModel.categoriesString isEqual: @"Bars, Mexican"]);
    XCTAssert([dataModel.distanceString isEqual:@"0.75 mi"]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
