//
//  JMObject.m
//  JSONMarshaller
//
//  Created by Ben Ridder on 2012-11-13.
//  Copyright (c) 2012 ridder. All rights reserved.
//

#import "JMObject.h"
#import "objc/runtime.h"

@implementation JMObject

- (void)unmarshal:(NSDictionary *)JSONDict;
{
    unsigned int outCount;
    __block objc_property_t *properties = class_copyPropertyList([self class], &outCount);

    // Small performance optimization: Load the property names and types into a dictionary
    // and iterate once instead of each time we hit a new object.
    for (int i = 0; i < outCount; i++) {
        objc_property_t prop = properties[i];
        NSLog(@"%s %s", property_getName(prop), getPropertyType(prop));
    }

    [JSONDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *selectorString = [self _selectorStringFromJSONKey:key];
        
        NSObject *composedObject = obj;
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *propertyName = [self _propertyStringFromJSONKey:key];
            NSString *propertyType = @"";
            for (int i = 0; i < outCount; i++) {
                if ([[NSString stringWithCString:property_getName(properties[i]) encoding:NSStringEncodingConversionAllowLossy] isEqualToString:propertyName]) {
                    propertyType = [NSString stringWithCString:getPropertyType(properties[i]) encoding:NSStringEncodingConversionAllowLossy];
                    break;
                }
            }
            if (![propertyType isEqualToString:@""]) {
                JMObject *newObject = [[(id)NSClassFromString(propertyType) alloc] init];
                [newObject unmarshal:obj];
                composedObject = newObject;
            } else {
                composedObject = nil;
            }
//            [[(id)NSClassFromString(@"") alloc] init];
        } else if ([obj isKindOfClass:[NSArray class]]) {
            NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:[obj count]];
            NSString *arrayPropertyString = [self _propertyStringFromJSONKey:key];
            NSArray *targetArray = [self performSelector:NSSelectorFromString(arrayPropertyString)];
            Class arrayType = [self classForArrayWithName:arrayPropertyString];
            for (id anObject in obj) {
                if ([anObject isKindOfClass:[NSDictionary class]]) {
                    JMObject *newObject = [[arrayType alloc] init];
                    [newObject unmarshal:anObject];
                    [newArray addObject:newObject];
                } else {
                    [newArray addObject:anObject];
                }
            }
             composedObject = newArray;
        }

        if ([self respondsToSelector:NSSelectorFromString(selectorString)]) {
            [self performSelector:NSSelectorFromString(selectorString) withObject:composedObject];
        }
    }];
}

- (NSDictionary *)marshal;
{
    NSAssert(NO, @"Subclass must override this method");
    return nil;
}

- (Class)classForArrayWithName:(NSString *)arrayName;
{
    NSAssert(NO, @"Subclass must override this method if arrays are expected");
    return nil;
}

- (NSString *)_selectorStringFromJSONKey:(NSString *)key;
{
    NSMutableArray *modifiedComponents = [[NSMutableArray alloc] init];
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"_"];
    NSArray *components = [key componentsSeparatedByCharactersInSet:charSet];

    [modifiedComponents addObject:@"set"];
    for (NSString *c in components) {
        [modifiedComponents addObject:[c capitalizedString]];
    }
    [modifiedComponents addObject:@":"];

    return [modifiedComponents componentsJoinedByString:@""];
}

- (NSString *)_propertyStringFromJSONKey:(NSString *)key;
{
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"_"];

    NSArray *components = [key componentsSeparatedByCharactersInSet:charSet];
    NSMutableArray *modifiedComponents = [[NSMutableArray alloc] initWithCapacity:[components count]];
    NSString *component = nil;
    for (int i = 0; i < [components count]; i++) {
        if (i == 0) {
            component = [components objectAtIndex:i];
        } else {
            component = [[components objectAtIndex:i] capitalizedString];
        }
        [modifiedComponents addObject:component];
    }
    return [modifiedComponents componentsJoinedByString:@""];
}

static const char * getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    printf("attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            /*
             if you want a list of what will be returned for these primitives, search online for
             "objective-c" "Property Attribute Description Examples"
             apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
             */
            return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "";
}

@end
