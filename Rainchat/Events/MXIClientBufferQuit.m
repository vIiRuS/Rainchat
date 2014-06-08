//
//  MXIClientBufferQuit.m
//  Rainchat
//
//  Created by Maximilian Gaß on 07.06.14.
//

#import "MXIClientBufferQuit.h"
#import "NSDictionary+MTLManipulationAdditions.h"


@implementation MXIClientBufferQuit
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:@{
                                                                                            @"fromNick" : @"nick",
                                                                                            @"message" : @"msg",
                                                                                            }];
}

- (NSString *)string {
    return [NSString stringWithFormat:@"<<< %@ quit (%@)", self.fromNick, self.message];
}

- (void)processWithClient:(MXIClient *)client buffer:(MXIClientBuffer *)buffer {
    [buffer.channel removeUserWithNick:self.fromNick];
}
@end
