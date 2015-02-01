//
//  GHEvent.m
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/30/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "GHIssueEvent.h"

@implementation GHIssueEvent
- (NSMutableDictionary *)mapping {
    NSMutableDictionary *mapping = [super mapping];
    mapping[@"identifier"] = @"id";
    mapping[@"apiURL"] = @"url";
    mapping[@"actor"] = @"actor";
    mapping[@"commitId"] = @"commit_id";
    mapping[@"eventType"] = @"event";
    mapping[@"createdAt@StringToDate"] = @"created_at";
    mapping[@"label"] = @"label";
    mapping[@"assignee"] = @"assignee";
    mapping[@"milestone"] = @"milestone";
    mapping[@"rename"] = @"rename";
    return mapping;
}
@end
