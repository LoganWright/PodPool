//
//  GHEventRename.m
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/30/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "GHIssueEventRename.h"

@implementation GHIssueEventRename
- (NSMutableDictionary *)mapping {
    NSMutableDictionary *mapping = [super mapping];
    mapping[@"fromName"] = @"from";
    mapping[@"toName"] = @"to";
    return mapping;
}
@end
