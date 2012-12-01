//
//  JMObject.h
//  JSONMarshaller
//
//  Created by Ben Ridder on 2012-11-13.
//  Copyright (c) 2012 ridder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMObject : NSObject

- (void)unmarshal:(NSDictionary *)JSONDict;
- (NSDictionary *)marshal;
- (Class)classForArrayWithName:(NSString *)arrayName;

@end
