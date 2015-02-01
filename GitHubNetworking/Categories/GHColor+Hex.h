//
//  GHColor+Hex.h
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/30/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#define GHColor UIColor
#elif TARGET_OS_MAC
#define GHColor NSColor
#endif

@interface GHColor (Hex)
- (NSString *)gh_hexRepresentation;
+ (GHColor *)gh_colorWithHexString:(NSString *)hexString;
@end
