//
//  NSCodable.m
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/29/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "NSCodable.h"
#import <objc/runtime.h>

@implementation NSCodable

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        for (NSString *property in [self properties]) {
            [self setValue:[aDecoder decodeObjectForKey:property] forKey:property];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    for (NSString *property in [self properties]) {
        [aCoder encodeObject:[self valueForKey:property] forKey:property];
    }
}

- (NSArray *)properties {
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableArray *propertyNames = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        NSString *stringName = [NSString stringWithUTF8String:name];
        [propertyNames addObject:stringName];
    }
    free(properties);
    return propertyNames;
}


@end
