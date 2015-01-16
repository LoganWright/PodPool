//
//  LGMarginLabel.m
//
//  Created by Logan Wright on 10/22/14.
//

#import "LGMarginLabel.h"

@implementation LGMarginLabel
- (void)drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.marginInsets)];
}
@end