//
//  GHIssueMilestone.h
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/24/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "JSONMapping.h"

@class GHUser;

@interface GHMilestone : JSONMappableObject
@property (copy, nonatomic) NSURL *apiURL;
@property (nonatomic) NSInteger number;
@property (nonatomic) NSInteger identifier;
@property (copy, nonatomic) NSURL *labelsURL;
@property (copy, nonatomic) NSString *state;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *milestoneDescription;
@property (strong, nonatomic) GHUser *creator;
@property (nonatomic) NSInteger openIssues;
@property (nonatomic) NSInteger closedIssues;

@property (copy, nonatomic) NSDate *createdAt;
@property (copy, nonatomic) NSDate *updatedAt;
@property (copy, nonatomic) NSDate *closedAt;
@property (copy, nonatomic) NSDate *dueOn;
@end
