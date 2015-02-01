//
//  GHCredential.h
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/28/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "JSONMapping.h"

@interface GHCredential : JSONMappableObject
@property (nonatomic, copy, readonly) NSString *accessToken;
@property (nonatomic, copy, readonly) NSString *tokenType;
@property (nonatomic, strong, readonly) NSArray *scopes;
@end
