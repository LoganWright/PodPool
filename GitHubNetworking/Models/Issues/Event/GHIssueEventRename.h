//
//  GHEventRename.h
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/30/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "JSONMapping.h"

@interface GHIssueEventRename : JSONMappableObject
@property (copy, nonatomic) NSString *fromName;
@property (copy, nonatomic) NSString *toName;
@end
