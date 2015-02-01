//
//  GHNetworking.h
//  GitIssues
//
//  Created by Logan Wright on 1/24/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class
GHCredential,
GHMilestone,
GHUser,
GHRepo,
GHIssue,
GHComment,
GHIssueEvent,
GHIssueLabel;

#if TARGET_OS_IPHONE
@class UIColor;
#define GHColor UIColor
#elif
@class NSColor;
#define GHColor NSColor
#endif

@interface GHNetworking : NSObject
@end

#pragma mark - Auth

@interface GHNetworking (Auth)
+ (void)requestAuthCredentialWithParameters:(NSDictionary *)params
                              andCompletion:(void(^)(GHCredential *credential, NSError *error))completion;
@end;

#pragma mark - Issues

@interface GHNetworking (Issues)
+ (void)getAllIssuesForRepo:(GHRepo *)repo
          withCompletion:(void(^)(NSArray *issues, NSError *error))completion;
+ (void)postIssueWithTitle:(NSString *)title
                      body:(NSString *)body
           milestoneNumber:(NSInteger)milestoneNumber
              assigneeName:(NSString *)assigneeName
             andLabelNames:(NSArray *)labelNames
                    toRepo:(GHRepo *)repo
            withCompletion:(void(^)(GHIssue *issue, NSError *error))completion;
+ (void)editIssueNumber:(NSInteger)issueNumber
              withTitle:(NSString *)title
                   body:(NSString *)body
                  state:(NSString *)state
        milestoneNumber:(NSInteger)milestoneNumber
           assigneeName:(NSString *)assigneeName
          andLabelNames:(NSArray *)labelNames
                 toRepo:(GHRepo *)repo
         withCompletion:(void (^)(GHIssue *, NSError *))completion;
@end

#pragma mark - IssuesComments

@interface GHNetworking (IssueComments)
+ (void)getCommentsForIssueNumber:(NSInteger)issueNumber
                           inRepo:(GHRepo *)repo
                   withCompletion:(void(^)(NSArray *comments, NSError *error))completion;
+ (void)getCommentWithId:(NSInteger)identifier
                 forRepo:(GHRepo *)repo
          withCompletion:(void(^)(GHComment *comment, NSError *error))completion;
+ (void)createCommentWithBody:(NSString *)body
               forIssueNumber:(NSInteger)issueNumber
                      andRepo:(GHRepo *)repo
               withCompletion:(void(^)(GHComment *comment, NSError *error))completion;
+ (void)editCommentWithBody:(NSString *)body
              forIdentifier:(NSInteger)identifier
                    forRepo:(GHRepo *)repo
             withCompletion:(void(^)(GHComment *comment, NSError *error))completion;
+ (void)deleteCommentWithIdentifier:(NSInteger)identifier
                            forRepo:(GHRepo *)repo
                     withCompletion:(void(^)(BOOL success, NSError *error))completion;
@end

#pragma mark - IssuesEvents

@interface GHNetworking (IssueEvents)
+ (void)getEventsForIssueNumber:(NSInteger)number
                         inRepo:(GHRepo *)repo
                 withCompletion:(void(^)(NSArray *events, NSError *error))completion;
+ (void)getEventsForRepo:(GHRepo *)repo
          withCompletion:(void(^)(NSArray *events, NSError *error))completion;
+ (void)getEventWithIdentifier:(NSInteger)identifier
                       forRepo:(GHRepo *)repo
                withCompletion:(void(^)(GHIssueEvent *event, NSError *error))completion;
@end

#pragma mark - IssuesLabels

@interface GHNetworking (IssueLabels)
+ (void)getAllLabelsForIssueNumber:(NSInteger)number
                           forRepo:(GHRepo *)repo
                    withCompletion:(void(^)(NSArray *labels, NSError *error))completion;
+ (void)addLabelsWithNames:(NSArray *)labelNames
             toIssueNumber:(NSInteger)issueNumber
                   forRepo:(GHRepo *)repo
            withCompletion:(void(^)(NSArray *labels, NSError *error))completion;
+ (void)removeLabelWithName:(NSString *)labelName
             forIssueNumber:(NSInteger)issueNumber
                    forRepo:(GHRepo *)repo
             withCompletion:(void(^)(BOOL success, NSError *error))completion;
+ (void)replaceAllLabelsForIssueNumber:(NSInteger)issueNumber
                                  repo:(GHRepo *)repo
                        withLabelNames:(NSArray *)labelNames
                         andCompletion:(void(^)(NSArray *labels, NSError *error))completion;
+ (void)removeAllLabelsForIssueNumber:(NSInteger)issueNumber
                                 repo:(GHRepo *)repo
                       withCompletion:(void(^)(BOOL success, NSError *error))completion;
@end

#pragma mark - Assignees

@interface GHNetworking (Assignees)
+ (void)getAvailableAssigneesForRepo:(GHRepo *)repo
                      withCompletion:(void(^)(NSArray *assignees, NSError *error))completion;
+ (void)validateAssigneeWithUsername:(NSString *)username
                             forRepo:(GHRepo *)repo
                      withCompletion:(void(^)(BOOL valid, NSError *error))completion;
@end

#pragma mark - Labels

@interface GHNetworking (Labels)
+ (void)getAvailableLabelsForRepo:(GHRepo *)repo
                   withCompletion:(void(^)(NSArray *labels, NSError *error))completion;
+ (void)getLabelForRepo:(GHRepo *)repo
               withName:(NSString *)name
          andCompletion:(void(^)(GHIssueLabel *label, NSError *error))completion;
+ (void)createLabelForRepo:(GHRepo *)repo
                  withName:(NSString *)name
                     color:(GHColor *)color
             andCompletion:(void(^)(GHIssueLabel *label, NSError *error))completion;
+ (void)editLabelNamed:(NSString *)label
             toNewName:(NSString *)newName
           andNewColor:(GHColor *)newColor
               forRepo:(GHRepo *)repo
        withCompletion:(void(^)(GHIssueLabel *label, NSError *error))completion;
+ (void)deleteLabelWithName:(NSString *)name
                    forRepo:(GHRepo *)repo
              andCompletion:(void(^)(BOOL successful, NSError *error))completion;
@end

#pragma mark - Milestones

@interface GHNetworking (Milestones)
+ (void)getAllMilestonesForRepo:(GHRepo *)repo
                 withCompletion:(void(^)(NSArray *milestones, NSError *error))completion;
// TODO: Declare as constants -- Probably enums converted under hood
/*
 state	string	The state of the milestone. Either open, closed, or all. Default: open
 sort	string	What to sort results by. Either due_date or completeness. Default: due_date
 direction	string	The direction of the sort. Either asc or desc. Default: asc
 */
+ (void)getAllMilestonesForRepo:(GHRepo *)repo
                      withState:(NSString *)state
                           sort:(NSString *)sort
                   andDirection:(NSString *)direction
                 withCompletion:(void (^)(NSArray *, NSError *))completion;
+ (void)getMilestoneForRepo:(GHRepo *)repo
                 withNumber:(NSInteger)milestoneNumber
              andCompletion:(void(^)(GHMilestone *milestone, NSError *error))completion;
// TODO: State is 'open' or 'closed' -- declare constants
+ (void)createMilestoneForRepo:(GHRepo *)repo
                     withTitle:(NSString *)title
                         state:(NSString *)state
                   description:(NSString *)description
                      andDueOn:(NSDate *)dueOn
                withCompletion:(void(^)(GHMilestone *newMilestone, NSError *error))completion;
+ (void)updateMilestoneNumber:(NSInteger)milestoneNumber
                      forRepo:(GHRepo *)repo
                    withTitle:(NSString *)title
                        state:(NSString *)state
                  description:(NSString *)description
                     andDueOn:(NSDate *)dueOn
               withCompletion:(void(^)(GHMilestone *newMilestone, NSError *error))completion;
+ (void)deleteMilestoneNumber:(NSInteger)milestoneNumber
                      forRepo:(GHRepo *)repo
               withCompletion:(void(^)(BOOL success, NSError *error))completion;
@end

#pragma mark - MilestoneLabels

@interface GHNetworking (MilestoneLabels)
+ (void)getAllLabelsForMilestoneNumber:(NSInteger)milestoneNumber
                                inRepo:(GHRepo *)repo
                        withCompletion:(void(^)(NSArray *labels, NSError *error))completion;
@end

#pragma mark - Markdown

@interface GHNetworking (MarkdownConversion)
+ (void)getHTMLFromMarkdown:(NSString *)markdown
            withContextRepo:(GHRepo *)repo
              andCompletion:(void(^)(NSString *html, NSError *error))completion;
@end
