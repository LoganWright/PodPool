//
//  NSArray+JSONMapping.h
//
//  Created by Logan Wright on 2/18/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (JSONMapping)
- (NSArray *)lg_mapToJSONMappableClass:(Class)classForMap;
@end
