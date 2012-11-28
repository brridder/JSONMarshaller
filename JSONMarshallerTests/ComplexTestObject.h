//
//  ComplexTestObject.h
//  JSONMarshaller
//
//  Created by Ben Ridder on 2012-11-13.
//  Copyright (c) 2012 ridder. All rights reserved.
//

#import "JMObject.h"
#import "TestObject.h"

@interface ComplexTestObject : JMObject

@property (nonatomic, retain) TestObject *testObject;
@property (nonatomic) NSNumber *someIntegerValue;

@end
