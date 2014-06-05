//
//  MXIClientUser.m
//  mxey-IRCCloud
//
//  Created by Phillip Thelen on 04/06/14.
//  Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//

#import "MXIClientUser.h"
#import "MTLValueTransformer.h"

@implementation MXIClientUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"nick" : @"nick",
             @"realName" : @"realname",
             @"ircServer" : @"ircserver",
             @"mode" : @"mode",
             @"away" : @"away"
             };
}

+ (NSValueTransformer *)awayJSONTransformer __unused {
    return [MTLValueTransformer transformerWithBlock:^id(id o) {
        double messageTimestampInMicroseconds = [o doubleValue];
        double messageTimestampInSeconds = messageTimestampInMicroseconds / 1000000;
        return [NSDate dateWithTimeIntervalSince1970:messageTimestampInSeconds];
    }];
}

@end
