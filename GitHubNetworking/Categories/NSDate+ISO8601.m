//
//  NSDate+ISO8601.m
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/30/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "NSDate+ISO8601.h"

@implementation NSDate (ISO8601)
+ (NSDate *)gh_dateWithISO8601String:(NSString *)dateString {
    NSDateFormatter *formatter = [self gh_iso8601DateFormatter];
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}
- (NSString *)gh_iso8601Representation {
    NSDateFormatter *formatter = [[self class] gh_iso8601DateFormatter];
    NSString *dateString = [formatter stringFromDate:self];
    return dateString;
}
+ (NSDateFormatter *)gh_iso8601DateFormatter {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    // Always use this locale when parsing fixed format date strings
    NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [formatter setLocale:posix];
    return formatter;
}
@end
