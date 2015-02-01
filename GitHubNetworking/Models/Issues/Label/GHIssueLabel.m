//
//  GHIssueLabel.m
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/24/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "GHIssueLabel.h"

@import UIKit;

@implementation GHIssueLabel
- (NSMutableDictionary *)mapping {
    NSMutableDictionary *mapping = [super mapping];
    mapping[@"url"] = @"url";
    mapping[@"name"] = @"name";
    mapping[@"color@GHHexToColor"] = @"color";
    return mapping;
}
@end
