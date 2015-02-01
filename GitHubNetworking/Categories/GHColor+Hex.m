//
//  GHColor+Hex.m
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/30/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "GHColor+Hex.h"

@implementation GHColor (Hex)
- (NSString *)gh_hexRepresentation {
    
    CGFloat rf, gf, bf, af;
    [self getRed:&rf green:&gf blue:&bf alpha:&af];
    
    int r,g,b,a;
    r = (int)(255.0 * rf);
    g = (int)(255.0 * gf);
    b = (int)(255.0 * bf);
    a = (int)(255.0 * af);
    
    NSString *hexString = [NSString stringWithFormat:@"%02x%02x%02x", r, g, b];
    return hexString;
}
+ (GHColor *)gh_colorWithHexString:(NSString *)hexString
{
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 - 8 characters
    if ([cString length] < 6) return nil;
    
    // strip 0X and # if they appear
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6) return nil;
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [GHColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
@end
