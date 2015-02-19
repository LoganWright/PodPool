//
//  NSObject+LGIntrospection.m
//
//  Created by Logan Wright on 2/18/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "NSObject+LGIntrospection.h"
#import <objc/runtime.h>

@implementation NSObject (LGIntrospection)

- (NSArray *)lg_propertyNames {
    NSMutableArray * propertyNames = [NSMutableArray array];
    
    // Fetch Properties
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    // Parse Out Properties
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        NSString * propertyName = [NSString stringWithUTF8String:name];
        [propertyNames addObject:propertyName];
    }
    
    // Free our properties
    free(properties);
    
    return propertyNames;
}

- (Class)lg_classForPropertyName:(NSString *)propertyName {
    objc_property_t prop = class_getProperty([self class], propertyName.UTF8String);
    const char * attr = property_getAttributes(prop);
    NSString *attributes = [NSString stringWithUTF8String:attr];
    NSArray *components = [attributes componentsSeparatedByString:@"\""];
    Class propertyClass;
    for (NSString *component in components) {
        Class class = NSClassFromString(component);
        if (class) {
            propertyClass = class;
            break;
        }
    }
    return propertyClass;
}

@end
