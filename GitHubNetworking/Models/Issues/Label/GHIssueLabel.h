//
//  GHIssueLabel.h
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/24/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "JSONMapping.h"

#if TARGET_OS_IPHONE
@class UIColor;
#define GHColor UIColor
#else
@class NSColor;
#define GHColor NSColor
#endif

@interface GHIssueLabel : JSONMappableObject
@property (strong, nonatomic) NSURL *url;
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) GHColor *color;
@end
