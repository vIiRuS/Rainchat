//
// Created by Maximilian Gaß on 06.04.14.
// Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//

#import "MXIClientUserStats.h"


@implementation MXIClientUserStats
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
        @"highlights" : @"highlightStrings",
    }];
}
@end
