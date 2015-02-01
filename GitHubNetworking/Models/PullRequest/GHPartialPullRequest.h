//
//  GHPullRequest.h
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/24/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "JSONMapping.h"

@interface GHPartialPullRequest : JSONMappableObject
@property (copy, nonatomic) NSURL *apiURL;
@property (copy, nonatomic) NSURL *htmlURL;
@property (copy, nonatomic) NSURL *diffURL;
@property (copy, nonatomic) NSURL  *patchURL;
@end
