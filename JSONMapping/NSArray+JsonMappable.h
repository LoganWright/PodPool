//
//  NSArray+JSONMappable.h
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/29/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (JSONMappable)
- (NSArray *)mapToJSONMappableClass:(Class)classForMap;
- (NSArray *)mapFromJSONMappableClass;
@end
