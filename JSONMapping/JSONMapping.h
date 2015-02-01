//
//  JSONObject.h
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/24/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "NSCodable.h"

#pragma mark - Object

@interface JSONMappableObject : NSCodable
- (NSMutableDictionary *)mapping;
- (instancetype)initWithJSONRepresentation:(NSDictionary *)jsonRepresentation;
@end

@interface JSONMappableObject (Parameters)
- (NSMutableDictionary *)parameterMapping;
- (NSDictionary *)jsonRepresentation;
@end

#pragma mark - Transformer

@interface JSONMappableTransformer : NSObject
+ (id)transform:(id)fromVal;
@end