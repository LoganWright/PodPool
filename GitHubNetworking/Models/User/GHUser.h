//
//  GHUser.h
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/24/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "JSONMapping.h"

@interface GHUser : JSONMappableObject
@property (copy, nonatomic) NSString *name;
@property (nonatomic) NSInteger identifier;
@property (copy, nonatomic) NSURL *avatarURL;
@property (copy, nonatomic) NSString *gravatarId;
@property (copy, nonatomic) NSURL *apiURL;
@property (copy, nonatomic) NSURL *htmlURL;
@property (copy, nonatomic) NSURL *followersURL;
@property (copy, nonatomic) NSURL *followingURL;
@property (copy, nonatomic) NSURL *gistsURL;
@property (copy, nonatomic) NSURL *starredURL;
@property (copy, nonatomic) NSURL *subscriptionsURL;
@property (copy, nonatomic) NSURL *organizationsURL;
@property (copy, nonatomic) NSURL *reposURL;
@property (copy, nonatomic) NSURL *eventsURL;
@property (copy, nonatomic) NSURL *receivedEventsURL;
@property (copy, nonatomic) NSString *type;
@property (nonatomic) BOOL siteAdmin;
@end
