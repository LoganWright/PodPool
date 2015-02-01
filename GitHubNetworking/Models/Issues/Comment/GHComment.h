//
//  GHComment.h
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/29/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "JSONMapping.h"

@class GHUser;

@interface GHComment : JSONMappableObject
@property (nonatomic) NSInteger identifier;
@property (copy, nonatomic) NSURL *apiURL;
@property (copy, nonatomic) NSURL *htmlURL;
@property (copy, nonatomic) NSString *bodyMarkdown;
@property (strong, nonatomic) GHUser *user;
@property (copy, nonatomic) NSDate *createdAt;
@property (copy, nonatomic) NSDate *updatedAt;
@end
