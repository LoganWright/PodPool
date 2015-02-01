//
//  GHIssue.m
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/24/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "GHIssue.h"

@class GHIssueLabel;

@implementation GHIssue
- (NSMutableDictionary *)mapping {
    NSMutableDictionary *mapping = [super mapping];
    mapping[@"identifier"] = @"id";
    mapping[@"apiURL"] = @"url";
    mapping[@"htmlURL"] = @"html_url";
    mapping[@"number"] = @"number";
    mapping[@"state"] = @"state";
    mapping[@"title"] = @"title";
    mapping[@"bodyMarkdown"] = @"body";
    mapping[@"user"] = @"user";
    mapping[@"labels@GHIssueLabel"] = @"labels";
    mapping[@"assignee"] = @"assignee";
    mapping[@"milestone"] = @"milestone";
    mapping[@"commentCount"] = @"comments";
    mapping[@"pullRequest"] = @"pull_request";
    mapping[@"closedAt@GHStringToDate"] = @"closed_at";
    mapping[@"createdAt@GHStringToDate"] = @"created_at";
    mapping[@"updatedAt@GHStringToDate"] = @"updated_at";
    mapping[@"locked"] = @"locked";
    return mapping;
}
@end