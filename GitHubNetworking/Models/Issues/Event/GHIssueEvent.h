//
//  GHEvent
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/30/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "JSONMapping.h"

@class GHUser, GHIssueLabel, GHMilestone, GHIssueEventRename;

@interface GHIssueEvent : JSONMappableObject
@property (nonatomic) NSInteger identifier;
@property (copy, nonatomic) NSURL *apiURL;
@property (strong, nonatomic) GHUser *actor;
@property (copy, nonatomic) NSString *commitId; // SHA
@property (copy, nonatomic) NSString *eventType; // open, closed, labeled, unlabeled, renamed
@property (copy, nonatomic) NSDate *createdAt;
@property (nonatomic, strong) GHIssueLabel *label;
@property (nonatomic, strong) GHUser *assignee;
@property (nonatomic, strong) GHMilestone *milestone;
@property (nonatomic, strong) GHIssueEventRename *rename;
@end

// TODO: Make Constants

/* Possible Events
 Events
 
 closed
 The issue was closed by the actor. When the commit_id is present, it identifies the commit that closed the issue using “closes / fixes #NN” syntax.
 reopened
 The issue was reopened by the actor.
 subscribed
 The actor subscribed to receive notifications for an issue.
 merged
 The issue was merged by the actor. The commit_id attribute is the SHA1 of the HEAD commit that was merged.
 referenced
 The issue was referenced from a commit message. The commit_id attribute is the commit SHA1 of where that happened.
 mentioned
 The actor was @mentioned in an issue body.
 assigned
 The issue was assigned to the actor.
 unassigned
 The actor was unassigned from the issue.
 labeled
 A label was added to the issue.
 unlabeled
 A label was removed from the issue.
 milestoned
 The issue was added to a milestone.
 demilestoned
 The issue was removed from a milestone.
 renamed
 The issue title was changed.
 locked
 The issue was locked by the actor.
 unlocked
 The issue was unlocked by the actor.
 head_ref_deleted
 The pull request’s branch was deleted.
 head_ref_restored
 The pull request’s branch was restored.
 
*/