//
//  JSONMarshallerTests.m
//  JSONMarshallerTests
//
//  Created by Ben Ridder on 2012-11-13.
//  Copyright (c) 2012 ridder. All rights reserved.
//

#import "JSONMarshallerTests.h"
#import "TestObject.h"
#import "ComplexTestObject.h"

@implementation JSONMarshallerTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testSimpleUnmarshalling;
{
    TestObject *testObject = [[TestObject alloc] init];

    NSString *testString = @"aString";
    NSDictionary *testDictionary = @{@"a_string" : testString};
    [testObject unmarshal:testDictionary];
    STAssertTrue([testObject.aString isEqualToString:testString], @"These objects should be the same");
}

- (void)testUnmarshallingWithComplexObjects;
{
    // Maybe should call these objects "ComposedTestObject"
    ComplexTestObject *complexTestObject = [[ComplexTestObject alloc] init];

    NSDictionary *testDictionary = @{@"test_object" : @{@"a_string" : @"aString"}, @"some_integer_value" : @(1)};
    [complexTestObject unmarshal:testDictionary];
    STAssertNotNil(complexTestObject.testObject, @"Child test object should not be nil");
    STAssertNotNil(complexTestObject.testObject.aString, @"Child test object's string should not be nil");
    
    NSNumber *val = complexTestObject.someIntegerValue;
    STAssertTrue([val intValue] == 1, @"Integer values should be the same");
}

- (void)testUnmarshallingWithArrays;
{

}

- (void)testASDF;
{
//    id aClass = 

}

@end
