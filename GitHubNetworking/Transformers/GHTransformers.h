//
//  GHTransformers.h
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/31/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "JSONMapping.h"

#pragma mark - ISO8601 -- NSDate

@interface GHStringToDate : JSONMappableTransformer
@end

@interface GHDateToString : JSONMappableTransformer
@end

#pragma mark - Hex -- Color

@interface GHHexToColor : JSONMappableTransformer
@end

@interface GHColorToHex : JSONMappableTransformer
@end

#pragma mark - Label -- Name

@interface GHLabelToName : JSONMappableTransformer
@end


#pragma mark - String --- URL

@interface GHStringToUrl : JSONMappableTransformer
@end
