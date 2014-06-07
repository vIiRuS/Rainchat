//
// Created by Maximilian Gaß on 06.04.14.
// Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//

#import "MXIClient.h"
#import "MXIClientUserStats.h"


@implementation MXIClientUserStats
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"highlightStrings" : @"highlights",
    };
}

- (void)processWithClient:(MXIClient *)client {
    client.highlightStrings = self.highlightStrings;
}
@end
