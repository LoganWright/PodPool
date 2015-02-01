//
//  NSDate+ISO8601.h
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/30/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ISO8601)
+ (NSDate *)gh_dateWithISO8601String:(NSString *)string;
- (NSString *)gh_iso8601Representation;
@end
