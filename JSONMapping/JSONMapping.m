//
//  JSONObject.m
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/24/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "JSONMapping.h"
#import <objc/runtime.h>

#import "NSArray+JSONMappable.h"

@implementation JSONMappableObject

#pragma mark - Initializer

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Init"
                                   reason:@"JSONMappableObjects must be initialized with a JSON Representation"
                                 userInfo:nil];
}
- (instancetype)initWithJSONRepresentation:(NSDictionary *)jsonRepresentation {
    self = [super init];
    if (self) {
        NSDictionary *mapping = [self mapping];
        for (__strong NSString *propertyName in mapping.allKeys) {
            NSString *associatedJSONKey = mapping[propertyName];
            id associatedValue = jsonRepresentation[associatedJSONKey];
            
            NSArray *components = [propertyName componentsSeparatedByString:@"@"];
            propertyName = components.firstObject;
            
            if (!associatedValue || [associatedValue isKindOfClass:[NSNull class]]) {
                [self setValue:nil forKey:propertyName];
                continue;
            }
            
            Class mappableClass;
            Class transformerClass;
            
            if (components.count == 2) {
                NSString *classOrTransformer = components.lastObject;
                Class class = NSClassFromString(classOrTransformer);
                if ([class isSubclassOfClass:[JSONMappableObject class]]) {
                    mappableClass = class;
                } else if ([class isSubclassOfClass:[JSONMappableTransformer class]]) {
                    transformerClass = class;
                } else {
                    NSLog(@"JMO: Unrecognized class or transformer: %@", classOrTransformer);
                }
            }
            
            if (!mappableClass) {
                Class propertyClass = [self classForPropertyName:propertyName];
                if ([propertyClass isSubclassOfClass:[JSONMappableObject class]]) {
                    mappableClass = propertyClass;
                }
            }
            
            // Transformer class takes precedence.
            if (transformerClass) {
                associatedValue = [transformerClass transform:associatedValue];
            } else if (mappableClass) {
                if ([associatedValue isKindOfClass:[NSArray class]]) {
                    associatedValue = [associatedValue mapToJSONMappableClass:mappableClass];
                } else {
                    associatedValue = [[mappableClass alloc] initWithJSONRepresentation:associatedValue];
                }
            }
            
            [self setValue:associatedValue forKey:propertyName];
        }
    }
    return self;
}

#pragma mark - Convenience

- (Class)classForPropertyName:(NSString *)propertyName {
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

#pragma mark - Mapping

- (NSMutableDictionary *)mapping {
    return [NSMutableDictionary dictionary];
}
@end

@implementation JSONMappableObject (Parameters)
- (NSMutableDictionary *)parameterMapping {
    return [NSMutableDictionary dictionary];
}
- (NSDictionary *)jsonRepresentation {
    NSMutableDictionary *representation = [NSMutableDictionary dictionary];
    NSDictionary *parameterMapping = [self parameterMapping];
    
    if (parameterMapping.allKeys.count == 0) {
        parameterMapping = [self mapping];
    }
    
    for (__strong NSString *propertyName in parameterMapping.allKeys) {
        NSString *associatedJsonKey = parameterMapping[propertyName];
        NSArray *components = [propertyName componentsSeparatedByString:@"@"];
        propertyName = components.firstObject;
        id val = [self valueForKey:propertyName];
        if (!val || [val isKindOfClass:[NSNull class]]) {
            continue;
        }
        
        Class mappableClass;
        Class transformerClass;
        
        if (components.count == 2) {
            NSString *classOrTransformer = components.lastObject;
            Class class = NSClassFromString(classOrTransformer);
            if ([class isSubclassOfClass:[JSONMappableObject class]]) {
                mappableClass = class;
            } else if ([class isSubclassOfClass:[JSONMappableTransformer class]]) {
                transformerClass = class;
            } else {
                NSLog(@"JMO: Unrecognized class or transformer: %@", classOrTransformer);
            }
        }
        
        if (!mappableClass) {
            Class propertyClass = [self classForPropertyName:propertyName];
            if ([propertyClass isSubclassOfClass:[JSONMappableObject class]]) {
                mappableClass = propertyClass;
            }
        }
        
        // Transformer class takes precedence.
        if (transformerClass) {
            val = [transformerClass transform:val];
        } else if (mappableClass) {
            if ([val isKindOfClass:[NSArray class]]) {
                val = [val mapFromJSONMappableClass];
            } else {
                val = [val jsonRepresentation];
            }
        }
        
        representation[associatedJsonKey] = val;
    }
    
    return [NSDictionary dictionaryWithDictionary:representation];
}
@end

#pragma mark - Transformer

@implementation JSONMappableTransformer
+ (id)transform:(id)fromVal {
    @throw [NSException exceptionWithName:@"Transform"
                                   reason:@"Must be overriden by subclass!"
                                 userInfo:nil];
}
@end
