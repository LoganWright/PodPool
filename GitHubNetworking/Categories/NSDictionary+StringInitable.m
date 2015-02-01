//
//  NSDictionary+StringInitable.m
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/28/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "NSDictionary+StringInitable.h"

@implementation NSDictionary (UrlQueryInitable)
+ (instancetype)dictionaryWithUrlQuery:(NSString *)urlQuery {
    
    NSArray *params = [urlQuery componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"&="]];
    if ((params.count % 2) != 0) {
        NSLog(@"ERROR: Parameters are required to be in the following format: `key=value&anotherKey=anotherValue`.  Unable to proccess: %@", urlQuery);
        return nil;
    }
    
    NSMutableDictionary *dictionaryRepresentation = [NSMutableDictionary dictionary];
    for (int i = 0; i < params.count; i += 2) {
        dictionaryRepresentation[params[i]] = params[i + 1];
    }
    return dictionaryRepresentation;
}
@end
