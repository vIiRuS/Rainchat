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

- (NSString *)string {
    return [NSString stringWithFormat:@"<%@> %@", self.fromNick, self.body];
}

- (void)checkForHighlights:(NSArray *)highlightStrings {
    [super checkForHighlights:highlightStrings];
    self.highlightsUser = @NO;
    for (NSString *highlightString in highlightStrings) {
        if ([self.body rangeOfString:highlightString].location != NSNotFound) {
            self.highlightsUser = @YES;
            break;
        }
    }
}
@end
