//
//  MXIClientBufferJoin.m
//  Rainchat
//
//  Created by Phillip on 05/06/14.
//  Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//

#import "MXIClientBufferJoin.h"
#import "NSDictionary+MTLManipulationAdditions.h"

@implementation MXIClientBufferJoin

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:@{
        @"fromNick" : @"nick",
        @"channelName" : @"chan"
    }];
}

- (NSString *)string {
    return [NSString stringWithFormat:@">>> %@ joined %@", self.fromNick, self.channelName];
}

- (void)processWithClient:(MXIClient *)client buffer:(MXIClientBuffer *)buffer {
    [buffer.channel insertUserWithNick:self.fromNick];
}
@end
