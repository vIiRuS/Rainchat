//
//  MXIBufferMessage.m
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 02.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import "MXIClientBufferMessage.h"

@implementation MXIClientBufferMessage

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"channel" : @"chan",
        @"message" : @"msg",
        @"fromNick" : @"from",
        @"connectionId" : @"cid",
        @"bufferId" : @"bid",
        @"eventId" : @"eid",
    };
}

- (NSDate *)timestamp {
    double messageTimestampInMicroseconds = [self.eventId doubleValue];
    double messageTimestampInSeconds = messageTimestampInMicroseconds / 1000000;
    return [NSDate dateWithTimeIntervalSince1970:messageTimestampInSeconds];
}
@end
