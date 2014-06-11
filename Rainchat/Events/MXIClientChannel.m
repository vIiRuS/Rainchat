//
//  MXIClientChannel.m
//  Rainchat
//
//  Created by Phillip Thelen on 04/06/14.
//

#import "MXIClientChannel.h"
#import "MTLValueTransformer.h"
#import <Mantle/NSValueTransformer+MTLPredefinedTransformerAdditions.h>
#import "MXIClientBuffer.h"
#import "MXIClientUser.h"

@implementation MXIClientChannel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"connectionId" : @"cid",
             @"bufferId" : @"bid",
             @"channelMode" : @"mode",
             @"channelType" : @"channel_type",
             @"topicText" : @"topic.text",
             @"topicChanged" : @"topic.time",
             @"topicNick" : @"topic.nick",
             @"members" : @"members"
             };
}

+ (NSValueTransformer *)topicChangedJSONTransformer __unused {
    return [MTLValueTransformer transformerWithBlock:^id(id o) {
        double messageTimestampInMicroseconds = [o doubleValue];
        double messageTimestampInSeconds = messageTimestampInMicroseconds / 1000000;
        return [NSDate dateWithTimeIntervalSince1970:messageTimestampInSeconds];
    }];
}

+ (NSValueTransformer *)membersJSONTransformer __unused {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[MXIClientUser class]];
}

-(void)removeUserWithNick:(NSString *)nick {
    for (MXIClientUser *user in self.members) {
        if ([user.nick isEqualToString:nick]) {
            [self.members removeObject:user];
            break;
        }
    }
}

-(void)insertUserWithNick:(NSString *)nick {
    MXIClientUser *user = [MXIClientUser newUserWithNick:nick];
    [self.members addObject:user];
}

- (void)processWithClient:(MXIClient *)client {
    MXIClientBuffer *buffer = client.buffers[self.bufferId];
    if (!buffer) {
        NSLog(@"Received buffer event for non-existent buffer: %@", self.bufferId);
        return;
    }
    buffer.channel = self;
}
@end
