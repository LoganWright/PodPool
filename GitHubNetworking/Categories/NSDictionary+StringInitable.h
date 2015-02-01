//
//  NSDictionary+StringInitable.h
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/28/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (UrlQueryInitable)
+ (instancetype)dictionaryWithUrlQuery:(NSString *)urlQuery;
@end
