//
// Created by Maximilian Gaß on 06.04.14.
// Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//

#import "MXIClientUserStats.h"


@implementation MXIClientUserStats
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"highlightStrings" : @"highlights",
    };
}
@end
