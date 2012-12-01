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
#import "ArrayTestObject.h"

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
    NSNumber *testNumber = @(17);
    NSDictionary *testDictionary = @{
                                    @"a_string" : testString,
                                    @"a_number" : testNumber
                                    };
    [testObject unmarshal:testDictionary];
    STAssertTrue([testObject.aString isEqualToString:testString], @"These objects should be the same");
    STAssertTrue([testObject.aNumber isEqualToNumber:testNumber], @"These numbers should be the same");

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

- (void)testUnmarshallingWithEmptyArrays;
{
    ArrayTestObject *arrayTestObject = [[ArrayTestObject alloc] init];
    // Test empty arrays
    NSDictionary *testDictionary = @{
        @"an_object_array" : @[],
        @"a_string_array" : @[],
        @"a_number_array" : @[],
        @"a_mixed_array" : @[]
    };

    [arrayTestObject unmarshal:testDictionary];
    STAssertNotNil(arrayTestObject.anObjectArray, @"Object array should not be nil");
    STAssertNotNil(arrayTestObject.aStringArray, @"String array should not be nil");
    STAssertNotNil(arrayTestObject.aNumberArray, @"Number array should not be nil");
    STAssertNotNil(arrayTestObject.aMixedArray, @"Mixed array should not be nil");
}

- (void)testUnmarshallingWithPopulatedArrays;
{
    ArrayTestObject *arrayTestObject = [[ArrayTestObject alloc] init];
    // Test empty arrays
    NSDictionary *testDictionary = @{
    @"an_object_array" : @[
        @{
            @"a_string" : @"test string",
            @"a_number" : @(1)
        },
        @{
            @"a_string" : @"a test string",
            @"a_number" : @(2)
        },
        @{
            @"a_string" : @"another test string",
            @"a_number" : @(3)
        },
        ],
    @"a_string_array" : @[@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j"],
    @"a_number_array" : @[@1, @2, @3, @4, @5, @19],
    @"a_mixed_array" : @[@"a", @1, @{@"a_string" : @"bbbb", @"a_number" : @3}] 
    };

    [arrayTestObject unmarshal:testDictionary];
    STAssertNotNil(arrayTestObject.anObjectArray, @"Object array should not be nil");
    STAssertNotNil(arrayTestObject.aStringArray, @"String array should not be nil");
    STAssertNotNil(arrayTestObject.aNumberArray, @"Number array should not be nil");
    STAssertNotNil(arrayTestObject.aMixedArray, @"Mixed array should not be nil");

    STAssertEquals([arrayTestObject.anObjectArray count], [[testDictionary objectForKey:@"an_object_array"] count], @"The sizes of the object arrays should be the same");
    STAssertEquals([arrayTestObject.aStringArray count], [[testDictionary objectForKey:@"a_string_array"] count], @"The sizes of the string arrays should be the same");
    STAssertEquals([arrayTestObject.aNumberArray count], [[testDictionary objectForKey:@"a_number_array"] count], @"The sizes of the number arrays should be the same");
    STAssertEquals([arrayTestObject.aMixedArray count], [[testDictionary objectForKey:@"a_mixed_array"] count], @"The sizes of the mixed arrays should be the same");
}


@end
