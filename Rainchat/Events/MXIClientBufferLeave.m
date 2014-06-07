//
//  MXIClientBufferLeave.m
//  Rainchat
//
//  Created by Phillip on 05/06/14.
//  Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//

#import "MXIClientBufferLeave.h"
#import "NSDictionary+MTLManipulationAdditions.h"

@implementation MXIClientBufferLeave

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:@{
        @"fromNick" : @"nick",
        @"message" : @"msg",
        @"channelName" : @"chan"
    }];
}

- (NSString *)string {
    return [NSString stringWithFormat:@"<<< %@ left %@ (%@)", self.fromNick, self.channelName, self.message];
}


@end
