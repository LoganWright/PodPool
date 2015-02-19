//
//  NSObject+JSONMapping.h
//
//  Created by Logan Wright on 2/18/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JSONMapping)

/**
 *  The initializer used to map from a JSON dictionary.  If initializing objects in a JSON Array, use `[NSArray mapToJSONMappableClass:]`
 *
 *  @param jsonRepresentation ...
 *
 *  @return an object initialized with the values of the JSON Representation
 */
- (instancetype)initWithJSONRepresentation:(NSDictionary *)jsonRepresentation NS_REQUIRES_SUPER;

/**
 *  For debugging
 *
 *  @return returns a description of the values set given the current mapping
 */
- (NSString *)mappableDescription;

@end
