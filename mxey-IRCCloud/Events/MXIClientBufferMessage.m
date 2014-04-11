//
//  MXIBufferMessage.m
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 02.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import "MXIClientBufferMessage.h"
#import "NSDictionary+MTLManipulationAdditions.h"

@implementation MXIClientBufferMessage

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:@{
        @"channel" : @"chan",
        @"message" : @"msg",
        @"fromNick" : @"from",
    }];
}
@end
