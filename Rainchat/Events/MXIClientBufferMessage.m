//
//  MXIBufferMessage.m
//  Rainchat
//
//  Created by Maximilian Gaß on 02.09.13.
//

#import "NSDictionary+MTLManipulationAdditions.h"
#import "MXIClientBufferMessage.h"

@implementation MXIClientBufferMessage

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:@{
        @"body" : @"msg",
        @"fromNick" : @"from",
    }];
}

- (NSString *)string {
    // Server messages have the nick set to null and we don't want to show "<null> servermessage"
    if (self.fromNick) {
        return [NSString stringWithFormat:@"&lt;%@&gt; %@", self.fromNick, self.body];
    } else {
        return [NSString stringWithFormat:@"%@", self.body];
    }
}

- (void)checkForHighlights:(NSArray *)highlightStrings {
    [super checkForHighlights:highlightStrings];
    self.highlightsUser = @NO;
    NSError *error;
    for (NSString *highlightString in highlightStrings) {
        NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:[NSString stringWithFormat:@"\\b%@\\b", highlightString]
                                                                          options:NSRegularExpressionCaseInsensitive
                                                                            error:&error];
        if ([regex numberOfMatchesInString:self.body options:0 range:NSMakeRange(0, [self.body length])] > 0) {
            self.highlightsUser = @YES;
            break;
        }
    }
}
@end
