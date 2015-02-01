//
//  GHTransformers.m
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/31/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "GHTransformers.h"
#import "NSDate+ISO8601.h"
#import "GHColor+Hex.h"

#pragma mark - ISO8601 -- NSDate

@implementation GHStringToDate
+ (id)transform:(id)fromVal {
    return [NSDate gh_dateWithISO8601String:fromVal];
}
@end
@implementation GHDateToString
+ (id)transform:(id)fromVal {
    return [(NSDate *)fromVal gh_iso8601Representation];
}
@end

#pragma mark - Hex -- Color

@implementation GHHexToColor
+ (id)transform:(id)fromVal {
    return [GHColor gh_colorWithHexString:fromVal];
}
@end
@implementation GHColorToHex
+ (id)transform:(id)fromVal {
    return [(GHColor *)fromVal gh_hexRepresentation];
}
@end

#pragma mark - Label -- Color

@implementation GHLabelToName
+ (id)transform:(id)fromVal {
    return [fromVal name];
}
@end

#pragma mark - String --- URL

@implementation GHStringToUrl
+ (id)transform:(id)fromVal {
    return [NSURL URLWithString:fromVal];
}
@end