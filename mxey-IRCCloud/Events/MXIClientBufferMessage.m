//
//  MXIBufferMessage.m
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 02.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import "MXIAppDelegate.h"
#import "NSDictionary+MTLManipulationAdditions.h"

@implementation MXIClientBufferMessage

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:@{
        @"body" : @"msg",
        @"fromNick" : @"from",
    }];
}

- (NSMutableDictionary *)stringAttributes {
    NSMutableDictionary *attributes = [super stringAttributes];
    if (self.highlightsUser.boolValue) {
        attributes[NSForegroundColorAttributeName] = [NSColor redColor];
    }
    return attributes;
}

- (NSString *)string {
    return [NSString stringWithFormat:@"<%@> %@", self.fromNick, self.body];
}

@end
