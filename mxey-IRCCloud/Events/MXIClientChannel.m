//
//  MXIClientChannel.m
//  mxey-IRCCloud
//
//  Created by Phillip Thelen on 04/06/14.
//  Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//

#import "MXIClientChannel.h"
#import "MTLValueTransformer.h"
#import <Mantle/NSValueTransformer+MTLPredefinedTransformerAdditions.h>
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

+ (NSValueTransformer *)membersJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[MXIClientUser class]];
}

@end
