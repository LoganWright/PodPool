//
//  GHPullRequest.m
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/24/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "GHPartialPullRequest.h"

@implementation GHPartialPullRequest
- (NSMutableDictionary *)mapping {
    NSMutableDictionary *mapping = [super mapping];
    mapping[@"apiURL"] = @"url";
    mapping[@"htmlURL"] = @"html_url";
    mapping[@"diffURL"] = @"diff_url";
    mapping[@"patchURL"] = @"patch_url";
    return mapping;
}
@end
