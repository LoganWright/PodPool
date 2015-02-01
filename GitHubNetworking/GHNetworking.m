//
//  GHNetworking.m
//  GitIssues
//
//  Created by Logan Wright on 1/24/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "GHNetworking.h"

#import "GHAuth.h"
#import "GHRepo.h"
#import "GHIssue.h"
#import "GHCredential.h"
#import "GHUser.h"
#import "GHComment.h"
#import "GHIssueEvent.h"
#import "GHIssueLabel.h"
#import "GHMilestone.h"

#import "NSDictionary+StringInitable.h"
#import "NSArray+JSONMappable.h"
#import "GHColor+Hex.h"
#import "NSDate+ISO8601.h"

#import <AFNetworking/AFNetworking.h>

static NSString * const GHNetworkingRootURL = @"https://api.github.com";
static NSString * const GHNetworkingVersionNumber = @"v3";

static NSString * const GHNetworkingHeaderAcceptTypeGitHubApiV3 = @"application/vnd.github.v3+json";
static NSString * const GHNetworkingHeaderAcceptTypeTextHtml = @"text/html";
static NSString * const GHNetworkingHeaderAcceptTypeApplicationJson = @"application/json";

static NSString * const GHNetworkingHeaderKeyAccept = @"Accept";
static NSString * const GHNetworkingHeaderKeyAuthorization = @"Authorization";
// Should be appended to the front of the access token(space is necessary).  Format: 'token valueOfToken'
static NSString * const GHNetworkingHeaderValueTokenPrefix = @"token ";

static NSString * const GHNetworkingEndpointRepos = @"repos";
static NSString * const GHNetworkingEndpointIssues = @"issues";
static NSString * const GHNetworkingEndpointAssignees = @"assignees";
static NSString * const GHNetworkingEndpointComments = @"comments";
static NSString * const GHNetworkingEndpointEvents = @"events";
static NSString * const GHNetworkingEndpointLabels = @"labels";
static NSString * const GHNetworkingEndpointMilestones = @"milestones";

@implementation GHNetworking

+ (AFHTTPRequestOperationManager *)operationManager {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[GHNetworkingHeaderAcceptTypeTextHtml,
                                                                              GHNetworkingHeaderAcceptTypeApplicationJson]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:GHNetworkingHeaderAcceptTypeGitHubApiV3 forHTTPHeaderField:GHNetworkingHeaderKeyAccept];

    NSString *accessToken = [[GHAuth currentCredential] accessToken];
    if (accessToken) {
        NSString *tokenHeader = [NSString stringWithFormat:@"%@%@", GHNetworkingHeaderValueTokenPrefix, accessToken];
        [manager.requestSerializer setValue:tokenHeader forHTTPHeaderField:GHNetworkingHeaderKeyAuthorization];
    }
    
    return manager;
}

@end


#pragma mark - Auth

static NSString * kGitHubAuthNetworkingAccessTokenUrl = @"https://github.com/login/oauth/access_token/";
static NSString * kGitHubAuthNetworkingResponseErrorKey = @"error";

@implementation GHNetworking (Auth)

+ (void)requestAuthCredentialWithParameters:(NSDictionary *)params andCompletion:(void(^)(GHCredential *credential, NSError *error))completion {
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:GHNetworkingHeaderAcceptTypeTextHtml
                     forHTTPHeaderField:GHNetworkingHeaderKeyAccept];
    
    [manager POST:kGitHubAuthNetworkingAccessTokenUrl
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSDictionary *responseDict = [self dictionaryFromResponseData:responseObject];
              if (!responseDict[kGitHubAuthNetworkingResponseErrorKey]) {
                  GHCredential *credential = [[GHCredential alloc] initWithJSONRepresentation:responseDict];
                  completion(credential, nil);
              } else {
                  // TODO: Setup Error System
                  NSError *err = [NSError errorWithDomain:@"io.loganwright.GitHubClient" code:101 userInfo:responseDict];
                  completion(nil, err);
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              completion(nil, error);
          }];
}

+ (NSDictionary *)dictionaryFromResponseData:(NSData *)responseData {
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    response = [response stringByRemovingPercentEncoding];
    NSDictionary *responseDict = [NSDictionary dictionaryWithUrlQuery:response];
    return responseDict;
}

@end

#pragma mark - Issues

@implementation GHNetworking (Issues)

+ (void)getAllIssuesForRepo:(GHRepo *)repo withCompletion:(void (^)(NSArray *, NSError *))completion {
    NSString *address = [self issuesAddressForRepo:repo];
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:address
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
             NSArray *issues = [responseObject mapToJSONMappableClass:[GHIssue class]];
             completion(issues, nil);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             completion(nil, error);
         }];
}

+ (void)postIssueWithTitle:(NSString *)title
                      body:(NSString *)body
           milestoneNumber:(NSInteger)milestoneNumber
              assigneeName:(NSString *)assigneeName
             andLabelNames:(NSArray *)labelNames
                    toRepo:(GHRepo *)repo
            withCompletion:(void(^)(GHIssue *issue, NSError *error))completion {
    
    NSString *address = [self issuesAddressForRepo:repo];
    
    NSMutableDictionary *postParameters = [NSMutableDictionary dictionary];
    if (title) {
        postParameters[@"title"] = title;
    }
    if (body) {
        postParameters[@"body"] = body;
    }
    if (milestoneNumber > 0) {
        postParameters[@"milestone"] = @(milestoneNumber);
    }
    if (assigneeName) {
        postParameters[@"assignee"] = assigneeName;
    }
    if (labelNames.count > 0) {
        postParameters[@"labels"] = labelNames;
    }
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:address
       parameters:postParameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              GHIssue *newIssue = [[GHIssue alloc] initWithJSONRepresentation:responseObject];
              completion(newIssue, nil);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              completion(nil, error);
          }];
}

+ (void)editIssueNumber:(NSInteger)issueNumber
              withTitle:(NSString *)title
                   body:(NSString *)body
                  state:(NSString *)state
        milestoneNumber:(NSInteger)milestoneNumber
           assigneeName:(NSString *)assigneeName
          andLabelNames:(NSArray *)labelNames
                 toRepo:(GHRepo *)repo
         withCompletion:(void (^)(GHIssue *, NSError *))completion {
    
    NSString *address = [self issuesAddressForRepo:repo];
    address = [NSString stringWithFormat:@"%@/%@", address, @(issueNumber)];
    
    NSMutableDictionary *postParameters = [NSMutableDictionary dictionary];
    if (title) {
        postParameters[@"title"] = title;
    }
    if (body) {
        postParameters[@"body"] = body;
    }
    if (milestoneNumber) {
        postParameters[@"milestone"] = @(milestoneNumber);
    }
    if (assigneeName) {
        postParameters[@"assignee"] = assigneeName;
    }
    if (labelNames.count > 0) {
        postParameters[@"labels"] = labelNames;
    }
    if (state) {
        postParameters[@"state"] = state;
    }
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager PATCH:address
        parameters:postParameters
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               GHIssue *issue = [[GHIssue alloc] initWithJSONRepresentation:responseObject];
               completion(issue, nil);
           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               completion(nil, error);
           }];
}


+ (NSString *)issuesAddressForRepo:(GHRepo *)repo {
    NSString *address = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",
                         GHNetworkingRootURL,
                         GHNetworkingEndpointRepos,
                         repo.owner,
                         repo.name,
                         GHNetworkingEndpointIssues];
    return address;
}

@end

#pragma mark - IssueComments

@implementation GHNetworking (IssueComments)
+ (void)getCommentsForIssueNumber:(NSInteger)issueNumber
                           inRepo:(GHRepo *)repo
                   withCompletion:(void(^)(NSArray *comments, NSError *error))completion; {
    
    NSString *address = [self commentsAddressForIssueNumber:issueNumber withRepo:repo];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:address
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
             NSArray *comments = [responseObject mapToJSONMappableClass:[GHComment class]];
             completion(comments, nil);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             completion(nil, error);
         }];
}

+ (void)getCommentWithId:(NSInteger)identifier
                 forRepo:(GHRepo *)repo
          withCompletion:(void(^)(GHComment *comment, NSError *error))completion {
    
    NSString *address = [self commentAddressForIdentifier:identifier withRepo:repo];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:address
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
             GHComment *comment = [[GHComment alloc] initWithJSONRepresentation:responseObject];
             completion(comment, nil);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             completion(nil, error);
         }];
}
+ (void)createCommentWithBody:(NSString *)body
               forIssueNumber:(NSInteger)issueNumber
                      andRepo:(GHRepo *)repo
               withCompletion:(void(^)(GHComment *comment, NSError *error))completion {
    
    NSString *address = [self commentsAddressForIssueNumber:issueNumber withRepo:repo];
    NSDictionary *params = @{@"body" : body};
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:address
       parameters:params
          success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
              GHComment *comment = [[GHComment alloc] initWithJSONRepresentation:responseObject];
              completion(comment, nil);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              completion(nil, error);
          }];
}
+ (void)editCommentWithBody:(NSString *)body
              forIdentifier:(NSInteger)identifier
                    forRepo:(GHRepo *)repo
             withCompletion:(void(^)(GHComment *comment, NSError *error))completion {
    
    NSString *address = [self commentAddressForIdentifier:identifier withRepo:repo];
    NSDictionary *params = @{@"body" : body};
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager PATCH:address
        parameters:params
           success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
               GHComment *comment = [[GHComment alloc] initWithJSONRepresentation:responseObject];
               completion(comment, nil);
           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               completion(nil, error);
           }];
}
+ (void)deleteCommentWithIdentifier:(NSInteger)identifier
                            forRepo:(GHRepo *)repo
                     withCompletion:(void(^)(BOOL success, NSError *error))completion {
    NSString *address = [self commentAddressForIdentifier:identifier withRepo:repo];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager DELETE:address
         parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                completion(YES, nil);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                completion(NO, error);
            }];
}

+ (NSString *)commentAddressForIdentifier:(NSInteger)identifier withRepo:(GHRepo *)repo {
    NSString *address = [self issuesAddressForRepo:repo];
    address = [NSString stringWithFormat:@"%@/%@/%@", address, GHNetworkingEndpointComments, @(identifier)];
    return address;
}
+ (NSString *)commentsAddressForIssueNumber:(NSInteger)issueNumber withRepo:(GHRepo *)repo {
    NSString *address = [self issuesAddressForRepo:repo];
    address = [NSString stringWithFormat:@"%@/%@/%@", address, @(issueNumber), GHNetworkingEndpointComments];
    return address;
}
@end

#pragma mark - IssueEvents

@implementation GHNetworking (IssueEvents)
+ (void)getEventsForIssueNumber:(NSInteger)number
                         inRepo:(GHRepo *)repo
                 withCompletion:(void (^)(NSArray *, NSError *))completion {
    NSString *address = [self issuesAddressForRepo:repo];
    address = [NSString stringWithFormat:@"%@/%@/%@", address, @(number), GHNetworkingEndpointEvents];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:address
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
             NSArray *events = [responseObject mapToJSONMappableClass:[GHIssueEvent class]];
             completion(events, nil);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             completion(nil, error);
         }];
}
+ (void)getEventsForRepo:(GHRepo *)repo
          withCompletion:(void(^)(NSArray *events, NSError *error))completion {
    NSString *address = [self issuesAddressForRepo:repo];
    address = [NSString stringWithFormat:@"%@/%@", address, GHNetworkingEndpointEvents];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:address
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
             NSArray *events = [responseObject mapToJSONMappableClass:[GHIssueEvent class]];
             completion(events, nil);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             completion(nil, error);
         }];
}
+ (void)getEventWithIdentifier:(NSInteger)identifier
                       forRepo:(GHRepo *)repo
                withCompletion:(void(^)(GHIssueEvent *event, NSError *error))completion {
    NSString *address = [self issuesAddressForRepo:repo];
    address = [NSString stringWithFormat:@"%@/%@/%@", address, GHNetworkingEndpointEvents, @(identifier)];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:address
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
             GHIssueEvent *event = [[GHIssueEvent alloc] initWithJSONRepresentation:responseObject];
             completion(event, nil);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             completion(nil, error);
         }];
}
@end

#pragma mark - IssueLabels

@implementation GHNetworking (IssueLabels)
+ (void)getAllLabelsForIssueNumber:(NSInteger)number
                           forRepo:(GHRepo *)repo
                    withCompletion:(void(^)(NSArray *labels, NSError *error))completion {
    NSString *address = [self issuesAddressForRepo:repo];
    address = [NSString stringWithFormat:@"%@/%@/%@", address, @(number), GHNetworkingEndpointLabels];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:address
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
             NSArray *labels = [responseObject mapToJSONMappableClass:[GHIssueLabel class]];
             completion(labels, nil);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             completion(nil, error);
         }];
}
+ (void)addLabelsWithNames:(NSArray *)labelNames
             toIssueNumber:(NSInteger)issueNumber
                   forRepo:(GHRepo *)repo
            withCompletion:(void(^)(NSArray *labels, NSError *error))completion {
    
    NSString *address =[self issuesAddressForRepo:repo];
    address = [NSString stringWithFormat:@"%@/%@/%@", address, @(issueNumber), GHNetworkingEndpointLabels];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:address
       parameters:labelNames
          success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
              NSArray *labels = [responseObject mapToJSONMappableClass:[GHIssueLabel class]];
              completion(labels, nil);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              completion(nil, error);
          }];
    
}
+ (void)removeLabelWithName:(NSString *)labelName
             forIssueNumber:(NSInteger)issueNumber
                    forRepo:(GHRepo *)repo
             withCompletion:(void(^)(BOOL success, NSError *error))completion {
    
    NSString *address =[self issuesAddressForRepo:repo];
    address = [NSString stringWithFormat:@"%@/%@/%@/%@", address, @(issueNumber), GHNetworkingEndpointLabels, labelName];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager DELETE:address
         parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                completion(YES, nil);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                completion(NO, error);
            }];
}
+ (void)replaceAllLabelsForIssueNumber:(NSInteger)issueNumber
                                  repo:(GHRepo *)repo
                        withLabelNames:(NSArray *)labelNames
                         andCompletion:(void(^)(NSArray *labels, NSError *error))completion {
    
    NSString *address =[self issuesAddressForRepo:repo];
    address = [NSString stringWithFormat:@"%@/%@/%@", address, @(issueNumber), GHNetworkingEndpointLabels];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager PUT:address
      parameters:labelNames
         success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
             NSArray *labels = [responseObject mapToJSONMappableClass:[GHIssueLabel class]];
             completion(labels, nil);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             completion(nil, error);
         }];
}
+ (void)removeAllLabelsForIssueNumber:(NSInteger)issueNumber
                                 repo:(GHRepo *)repo
                       withCompletion:(void(^)(BOOL success, NSError *error))completion {
    
    NSString *address =[self issuesAddressForRepo:repo];
    address = [NSString stringWithFormat:@"%@/%@/%@", address, @(issueNumber), GHNetworkingEndpointLabels];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager DELETE:address
         parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                completion(YES, nil);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                completion(NO, error);
            }];
}
@end

#pragma mark - Assignees

@implementation GHNetworking (Assignees)

+ (void)getAvailableAssigneesForRepo:(GHRepo *)repo
                      withCompletion:(void(^)(NSArray *assignees, NSError *error))completion {
    NSString *address = [self assigneesAddressForRepo:repo];
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:address
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
             NSArray *assignees = [responseObject mapToJSONMappableClass:[GHUser class]];
             completion(assignees, nil);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             completion(nil, error);
         }];
}

+ (void)validateAssigneeWithUsername:(NSString *)username
                             forRepo:(GHRepo *)repo
                      withCompletion:(void(^)(BOOL valid, NSError *error))completion {
    NSString *address = [self assigneesAddressForRepo:repo];
    address = [NSString stringWithFormat:@"%@/%@", address, username];
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:address
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
             completion(YES, nil);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             completion(NO, error);
         }];
}

+ (NSString *)assigneesAddressForRepo:(GHRepo *)repo {
    NSString *address = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",
                         GHNetworkingRootURL,
                         GHNetworkingEndpointRepos,
                         repo.owner,
                         repo.name,
                         GHNetworkingEndpointAssignees];
    return address;
}

@end

#pragma mark - Labels

@implementation GHNetworking (Labels)
+ (void)getAvailableLabelsForRepo:(GHRepo *)repo
                   withCompletion:(void(^)(NSArray *labels, NSError *error))completion {
    NSString *address = [self labelsAddressForRepo:repo];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:address
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
             NSArray *labels = [responseObject mapToJSONMappableClass:[GHIssueLabel class]];
             completion(labels, nil);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             completion(nil, error);
         }];
}
+ (void)getLabelForRepo:(GHRepo *)repo
               withName:(NSString *)name
          andCompletion:(void(^)(GHIssueLabel *label, NSError *error))completion {
    NSString *address = [self labelsAddressForRepo:repo];
    address = [NSString stringWithFormat:@"%@/%@", address, name];
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:address
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
             GHIssueLabel *label = [[GHIssueLabel alloc] initWithJSONRepresentation:responseObject];
             completion(label, nil);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             completion(nil, error);
         }];
}
+ (void)createLabelForRepo:(GHRepo *)repo
                  withName:(NSString *)name
                     color:(GHColor *)color
             andCompletion:(void(^)(GHIssueLabel *label, NSError *error))completion {
    NSString *address = [self labelsAddressForRepo:repo];
    NSString *hexColor = [color gh_hexRepresentation];
    NSDictionary *params = @{@"name" : name,
                             @"color" : hexColor};
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:address
       parameters:params
          success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
              GHIssueLabel *label = [[GHIssueLabel alloc] initWithJSONRepresentation:responseObject];
              completion(label, nil);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              completion(nil, error);
          }];
    
}
+ (void)editLabelNamed:(NSString *)labelName
             toNewName:(NSString *)newName
           andNewColor:(GHColor *)newColor
               forRepo:(GHRepo *)repo
        withCompletion:(void(^)(GHIssueLabel *label, NSError *error))completion {
    
    NSString *address = [self labelsAddressForRepo:repo];
    address = [NSString stringWithFormat:@"%@/%@", address, labelName];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"name"] = newName ?: newName;
    params[@"color"] = [newColor gh_hexRepresentation];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager PATCH:address
        parameters:params
           success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
               GHIssueLabel *label = [[GHIssueLabel alloc] initWithJSONRepresentation:responseObject];
               completion(label, nil);
           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               completion(nil, error);
           }];
}
+ (void)deleteLabelWithName:(NSString *)name
                    forRepo:(GHRepo *)repo
              andCompletion:(void(^)(BOOL successful, NSError *error))completion {
    
    NSString *address = [self labelsAddressForRepo:repo];
    address = [NSString stringWithFormat:@"%@/%@", address, name];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager DELETE:address
         parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                completion(YES, nil);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                completion(NO, error);
            }];
}
+ (NSString *)labelsAddressForRepo:(GHRepo *)repo {
    NSString *address = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",
                         GHNetworkingRootURL,
                         GHNetworkingEndpointRepos,
                         repo.owner,
                         repo.name,
                         GHNetworkingEndpointLabels];
    return address;
}
@end

#pragma mark - Milestones

@implementation GHNetworking (Milestones)
// TODO: Implement milestones calls
+ (void)getAllMilestonesForRepo:(GHRepo *)repo
                 withCompletion:(void(^)(NSArray *milestones, NSError *error))completion {
    [self getAllMilestonesForRepo:repo
                        withState:nil
                             sort:nil
                     andDirection:nil
                   withCompletion:completion];
}
+ (void)getAllMilestonesForRepo:(GHRepo *)repo
                      withState:(NSString *)state
                           sort:(NSString *)sort
                   andDirection:(NSString *)direction
                 withCompletion:(void (^)(NSArray *, NSError *))completion {
    NSString *address = [self milestonesAddressForRepo:repo];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (state) {
        params[@"state"] = state;
    }
    if (sort) {
        params[@"sort"] = sort;
    }
    if (direction) {
        params[@"direction"] = direction;
    }
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:address
      parameters:params
         success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
             NSArray *milestones = [responseObject mapToJSONMappableClass:[GHMilestone class]];
             completion(milestones, nil);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             completion(nil, error);
         }];
    
}
+ (void)getMilestoneForRepo:(GHRepo *)repo
                 withNumber:(NSInteger)milestoneNumber
              andCompletion:(void(^)(GHMilestone *milestone, NSError *error))completion {
    NSString *address = [self milestonesAddressForRepo:repo];
    address = [NSString stringWithFormat:@"%@/%@", address, @(milestoneNumber)];
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:address
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
             GHMilestone *milestone = [[GHMilestone alloc] initWithJSONRepresentation:responseObject];
             completion(milestone, nil);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             completion(nil, error);
         }];
}
// TODO: State is 'open' or 'closed' -- declare constants
+ (void)createMilestoneForRepo:(GHRepo *)repo
                     withTitle:(NSString *)title
                         state:(NSString *)state
                   description:(NSString *)description
                      andDueOn:(NSDate *)dueOn
                withCompletion:(void(^)(GHMilestone *newMilestone, NSError *error))completion {
    
    NSString *address = [self milestonesAddressForRepo:repo];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (title) {
        params[@"title"] = title;
    }
    if (state) {
        params[@"state"] = state;
    }
    if (description) {
        params[@"description"] = description;
    }
    if (dueOn) {
        params[@"due_on"] = [dueOn gh_iso8601Representation];
    }
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    
    [manager POST:address
       parameters:params
          success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
              GHMilestone *milestone = [[GHMilestone alloc] initWithJSONRepresentation:responseObject];
              completion(milestone, nil);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              completion(nil, error);
          }];
    
}
+ (void)updateMilestoneNumber:(NSInteger)milestoneNumber
                      forRepo:(GHRepo *)repo
                    withTitle:(NSString *)title
                        state:(NSString *)state
                  description:(NSString *)description
                     andDueOn:(NSDate *)dueOn
               withCompletion:(void(^)(GHMilestone *newMilestone, NSError *error))completion {
    NSString *address = [self milestonesAddressForRepo:repo];
    address = [NSString stringWithFormat:@"%@/%@", address, @(milestoneNumber)];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (title) {
        params[@"title"] = title;
    }
    if (state) {
        params[@"state"] = state;
    }
    if (description) {
        params[@"description"] = description;
    }
    if (dueOn) {
        params[@"due_on"] = [dueOn gh_iso8601Representation];
    }
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    
    [manager PATCH:address
       parameters:params
          success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
              GHMilestone *milestone = [[GHMilestone alloc] initWithJSONRepresentation:responseObject];
              completion(milestone, nil);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              completion(nil, error);
          }];
}
+ (void)deleteMilestoneNumber:(NSInteger)milestoneNumber
                      forRepo:(GHRepo *)repo
               withCompletion:(void(^)(BOOL success, NSError *error))completion {
    NSString *address = [self milestonesAddressForRepo:repo];
    address = [NSString stringWithFormat:@"%@/%@", address, @(milestoneNumber)];

    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager DELETE:address
        parameters:nil
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               completion(YES, nil);
           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               completion(NO, error);
           }];
}

+ (NSString *)milestonesAddressForRepo:(GHRepo *)repo {
    NSString *address = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",
                         GHNetworkingRootURL,
                         GHNetworkingEndpointRepos,
                         repo.owner,
                         repo.name,
                         GHNetworkingEndpointMilestones];
    return address;
}
@end

#pragma mark - MilestoneLabels

@implementation GHNetworking (MilestoneLabels)
+ (void)getAllLabelsForMilestoneNumber:(NSInteger)milestoneNumber
                                inRepo:(GHRepo *)repo
                        withCompletion:(void(^)(NSArray *labels, NSError *error))completion {
    NSString *address =[self milestonesAddressForRepo:repo];
    address = [NSString stringWithFormat:@"%@/%@/%@", address, @(milestoneNumber), GHNetworkingEndpointLabels];
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:address
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
             NSArray *labels = [responseObject mapToJSONMappableClass:[GHIssueLabel class]];
             completion(labels, nil);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             completion(nil, error);
         }];
}
@end

#pragma mark - Markdown

@implementation GHNetworking (MarkdownConversion)

+ (void)getHTMLFromMarkdown:(NSString *)markdown
            withContextRepo:(GHRepo *)repo
              andCompletion:(void (^)(NSString *, NSError *))completion {
    NSString *address = [NSString stringWithFormat:@"%@/markdown", GHNetworkingRootURL];
    
    /*
     The rendering mode. Can be either:
     * markdown to render a document as plain Markdown, just like README files are rendered.
     * gfm to render a document as user-content, e.g. like user comments or issues are rendered. In GFM mode, hard line breaks are always taken into account, and issue and user mentions are linked accordingly.
     Default: markdown
     */
    NSString *mode = @"gfm";
    
    /*
     The repository context. Only taken into account when rendering as gfm
     */
    NSString *context = [NSString stringWithFormat:@"%@/%@", repo.owner, repo.name];
    
    NSDictionary *params = @{@"text" : markdown,
                             @"mode" : mode,
                             @"context" : context};
    //    NSString *address = [NSString stringWithFormat:@"%@/%@/vmg/redcarpet/%@?page=0", GHNetworkingRootURL, GHNetworkingEndpointRepos, GHNetworkingEndpointIssues];
    AFHTTPRequestOperationManager *manager = [self operationManager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:address parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *sent = markdown;
        NSLog(@"Sent: %@ Got: %@", sent, responseObject);
        NSLog(@"Resp: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"IssueFetch Failed w/ Error w/ error: %@", error);
        
    }];
}

@end
