//
//  GHRepo.h
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/29/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "NSCodable.h"

@interface GHRepo : NSCodable
@property (strong, nonatomic) NSString *owner;
@property (strong, nonatomic) NSString *name;
+ (instancetype)repoNamed:(NSString *)name withOwner:(NSString *)owner;
@end
