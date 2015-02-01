//
//  GHUser.m
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/24/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "GHUser.h"

@implementation GHUser
- (NSMutableDictionary *)mapping {
    NSMutableDictionary *mapping = [super mapping];
    mapping[@"name"] = @"login";
    mapping[@"identifier"] = @"id";
    mapping[@"avatarURL"] = @"avatar_url";
    mapping[@"gravatarId"] = @"gravatar_id";
    mapping[@"apiURL"] = @"url";
    mapping[@"htmlURL"] = @"html_url";
    mapping[@"followersURL"] = @"followers_url";
    mapping[@"followingURL"] = @"following_url";
    mapping[@"gistsURL"] = @"gists_url";
    mapping[@"starredURL"] = @"starred_url";
    mapping[@"subscriptionsURL"] = @"subscriptions_url";
    mapping[@"organizationsURL"] = @"organizations_url";
    mapping[@"reposURL"] = @"repos_url";
    mapping[@"eventsURL"] = @"events_url";
    mapping[@"receivedEventsURL"] = @"received_events_url";
    mapping[@"type"] = @"type";
    mapping[@"siteAdmin"] = @"site_admin";
    return mapping;
}
@end
