//
//  GHIssue.h
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/24/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "JSONMapping.h"

@class GHUser;
@class GHMilestone;
@class GHPartialPullRequest;

@interface GHIssue : JSONMappableObject
@property (nonatomic) NSInteger identifier;
@property (copy, nonatomic) NSURL *apiURL;
@property (copy, nonatomic) NSURL *htmlURL;
@property (nonatomic) NSInteger number;
@property (copy, nonatomic) NSString *state;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *bodyMarkdown;
@property (strong, nonatomic) GHUser *user;
@property (strong, nonatomic) NSArray *labels; // GHIssueLabel
@property (strong, nonatomic) GHUser *assignee;
@property (strong, nonatomic) GHMilestone *milestone;
@property (strong, nonatomic) GHPartialPullRequest *pullRequest;
@property (nonatomic) NSInteger commentCount;
@property (copy, nonatomic) NSDate *closedAt;
@property (copy, nonatomic) NSDate *createdAt;
@property (copy, nonatomic) NSDate *updatedAt;
@property (nonatomic) BOOL locked;
@end