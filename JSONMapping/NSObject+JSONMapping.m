//
//  NSObject+JSONMapping.m
//
//  Created by Logan Wright on 2/18/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "NSObject+JSONMapping.h"

#import "JSONMappableObject.h"
#import "JSONMappableTransformer.h"
#import "NSObject+LGIntrospection.h"
#import "NSArray+JSONMapping.h"

static BOOL LOG = NO;

@implementation NSObject (JSONMapping)

- (instancetype)initWithJSONRepresentation:(NSDictionary *)jsonRepresentation {
    self = [self init];
    if (self) {
        NSDictionary *mapping = [self mapping];
        NSDictionary *defaults = [self defaultPropertyValues];
        for (NSString *propertyNameKey in mapping.allKeys) {
            NSString *associatedJSONKeyPath = mapping[propertyNameKey];
            id associatedValue = [jsonRepresentation valueForKeyPath:associatedJSONKeyPath];
            NSArray *components = [propertyNameKey componentsSeparatedByString:@"@"];
            NSString *propertyName = components.firstObject;
            
            if (!associatedValue || associatedValue == [NSNull null]) {
                id defaultVal = defaults[propertyName];
                if (LOG) {
                    NSLog(@"%@ : SETTING (NIL || DEFAULT) : val : %@ : propertyName: %@", NSStringFromClass([self class]), defaultVal ?: @"**NIL**", propertyName);
                }
                [self setValue:defaultVal forKeyPath:propertyName];
                continue;
            }
            
            Class mappableClass;
            Class transformerClass;
            
            // If components == 2, then the user has declared either a transformer or a mappable class in addition.
            if (components.count == 2) {
                NSString *classOrTransformer = components.lastObject;
                Class class = NSClassFromString(classOrTransformer);
                if ([class conformsToProtocol:@protocol(JSONMappableObject)]) {
                    mappableClass = class;
                } else if ([class isSubclassOfClass:[JSONMappableTransformer class]]) {
                    transformerClass = class;
                } else {
                    NSLog(@"Unrecognized class or transformer: %@", classOrTransformer);
                }
            }
            
            if (!mappableClass) {
                Class propertyClass = [self lg_classForPropertyName:propertyName];
                if ([propertyClass conformsToProtocol:@protocol(JSONMappableObject)]) {
                    mappableClass = propertyClass;
                }
            }
            
            // Transformer class takes precedence.
            if (transformerClass) {
                associatedValue = [transformerClass transform:associatedValue];
            } else if (mappableClass) {
                if ([associatedValue isKindOfClass:[NSArray class]]) {
                    associatedValue = [associatedValue lg_mapToJSONMappableClass:mappableClass];
                } else {
                    associatedValue = [[mappableClass alloc] initWithJSONRepresentation:associatedValue];
                }
            }
            
            if (LOG) {
                NSLog(@"%@ : SETTING : val : %@ : propertyName: %@", NSStringFromClass([self class]), associatedValue, propertyName);
            }
            
            [self setValue:associatedValue forKeyPath:propertyName];
        }
    }
    return self;
}

- (NSString *)mappableDescription {
    NSString *descript = @"";
    
    NSDictionary *mapping = [self mapping];
    for (NSString *propertyNameKey in mapping.allKeys) {
        NSArray *components = [propertyNameKey componentsSeparatedByString:@"@"];
        NSString *propertyName = components.firstObject;
        id val = [self valueForKeyPath:propertyName];
        descript  = [NSString stringWithFormat:@"%@ \n %@ : %@", descript, propertyName, val];
    }
    return descript;
}

#pragma mark - Private

/*
 These are declared to allow for calls in this class.  These will be overridden in JSONMappableObject protocol objects
 */

- (NSMutableDictionary *)mapping {
    @throw [NSException exceptionWithName:@"Mapping not implemented"
                                   reason:@"Must be overriden by subclass!"
                                 userInfo:nil];
}

/**
 *  Not necessary to implement this
 *
 *  @return the default property mapping to use for the current class
 */
- (NSMutableDictionary *)defaultPropertyValues {
    return nil;
}

@end
