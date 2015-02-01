//
//  NSArray+JSONMappable.m
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/29/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "NSArray+JSONMappable.h"
#import "JSONMapping.h"

@implementation NSArray (JSONMappable)

- (NSArray *)mapToJSONMappableClass:(Class)classForMap {
    [self assertClassIsMappable:classForMap];
    
    NSMutableArray *mapped = [NSMutableArray array];
    for (NSDictionary *rawObject in self) {
        id mappedObject = [[classForMap alloc] initWithJSONRepresentation:rawObject];
        [mapped addObject:mappedObject];
    }
    return [NSArray arrayWithArray:mapped];
}

- (NSArray *)mapFromJSONMappableClass {
    NSMutableArray *mapped = [NSMutableArray array];
    for (JSONMappableObject *ob in self) {
        NSDictionary *jsonRepresentation = [ob jsonRepresentation];
        [mapped addObject:jsonRepresentation];
    }
    return [NSArray arrayWithArray:mapped];
}

- (void)assertClassIsMappable:(Class)classForMap {
    BOOL isJsonMappable = [classForMap isSubclassOfClass:[JSONMappableObject class]];
    NSString *assertionMsg = @"This method requires a JSONMappableClass!";
    NSAssert(isJsonMappable, assertionMsg);
}

@end
