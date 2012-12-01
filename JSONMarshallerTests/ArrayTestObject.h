//
//  ArrayTestObject.h
//  JSONMarshaller
//
//  Created by Ben Ridder on 2012-11-30.
//  Copyright (c) 2012 ridder. All rights reserved.
//

#import "JMObject.h"

@interface ArrayTestObject : JMObject

@property (nonatomic, retain) NSArray *anObjectArray;
@property (nonatomic, retain) NSArray *aStringArray;
@property (nonatomic, retain) NSArray *aNumberArray;
@property (nonatomic, retain) NSArray *aMixedArray;

@end
