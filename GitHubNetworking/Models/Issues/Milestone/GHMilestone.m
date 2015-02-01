//
//  GHIssueMilestone.m
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/24/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "GHMilestone.h"

@implementation GHMilestone
- (NSMutableDictionary *)mapping {
    NSMutableDictionary *mapping = [super mapping];
    mapping[@"apiURL"] = @"url";
    mapping[@"number"] = @"number";
    mapping[@"state"] = @"state";
    mapping[@"title"] = @"title";
    mapping[@"identifier"] = @"id";
    mapping[@"labelsURL"] = @"labels_url";
    mapping[@"milestoneDescription"] = @"description";
    mapping[@"creator"] = @"creator";
    mapping[@"openIssues"] = @"open_issues";
    mapping[@"closedIssues"] = @"closed_issues";
    mapping[@"createdAt@GHStringToDate"] = @"created_at";
    mapping[@"updatedAt@GHStringToDate"] = @"updated_at";
    mapping[@"closedAt@GHStringToDate"] = @"closed_at";
    mapping[@"dueOn"] = @"due_on";
    return mapping;
}
@end
