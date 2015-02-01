//
//  GHCredential.m
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/28/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "GHCredential.h"

@interface GHCredential ()
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *bearerType;
@property (nonatomic, strong) NSArray *scopes;
@end

@implementation GHCredential

- (NSMutableDictionary *)mapping {
    NSMutableDictionary *mapping = [super mapping];
    mapping[@"accessToken"] = @"access_token";
    mapping[@"tokenType"] = @"token_type";
    mapping[@"scopes"] = @"scope";
    return mapping;
}

- (void)setScopes:(NSArray *)scopes {
    if ([scopes isKindOfClass:[NSString class]]) {
        _scopes = [(NSString *)scopes componentsSeparatedByString:@","];
    } else {
        _scopes = scopes;
    }
}

@end
