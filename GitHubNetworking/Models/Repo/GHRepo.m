//
//  GHRepo.m
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/29/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "GHRepo.h"

@implementation GHRepo
+ (instancetype)repoNamed:(NSString *)name withOwner:(NSString *)owner {
    GHRepo *repo = [GHRepo new];
    repo.name = name;
    repo.owner = owner;
    return repo;
}
@end
