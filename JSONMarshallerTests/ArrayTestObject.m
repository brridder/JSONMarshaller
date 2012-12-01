//
//  ArrayTestObject.m
//  JSONMarshaller
//
//  Created by Ben Ridder on 2012-11-30.
//  Copyright (c) 2012 ridder. All rights reserved.
//

#import "ArrayTestObject.h"
#import "TestObject.h"

@implementation ArrayTestObject

- (Class)classForArrayWithName:(NSString *)arrayName;
{
    if ([arrayName isEqualToString:@"anObjectArray"]) {
        return [TestObject class];
    } else if ([arrayName isEqualToString:@"aStringArray"]) {
        return [NSString class];
    } else if ([arrayName isEqualToString:@"aNumberArray"]) {
        return [NSNumber class];
    } else if ([arrayName isEqualToString:@"aMixedArray"]) {
        return [TestObject class];
    }
}


@end
