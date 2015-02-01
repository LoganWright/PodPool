//
//  GHComment.m
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/29/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "GHComment.h"

@implementation GHComment
- (NSMutableDictionary *)mapping {
    NSMutableDictionary *mapping = [super mapping];
    mapping[@"identifier"] = @"id";
    mapping[@"apiURL"] = @"url";
    mapping[@"htmlURL"] = @"html_url";
    mapping[@"bodyMarkdown"] = @"body";
    mapping[@"user"] = @"user";
    mapping[@"createdAt@GHStringToDate"] = @"created_at";
    mapping[@"updatedAt@GHStringToDate"] = @"updated_at";
    return mapping;
}
@end
