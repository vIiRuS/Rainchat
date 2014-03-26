//
//  MXIBufferMessage.m
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 02.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import "MXIClientBufferMessage.h"

NSString *const MXIClientBufferMessageNotification = @"net.mxey.rainchat.MXIClientBufferMessageNotification";


@implementation MXIClientBufferMessage

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
        @"chan" : @"channel",
        @"msg" : @"message",
        @"from" : @"fromNick",
        @"cid" : @"connectionId",
        @"bid" : @"bufferId",
        @"eid" : @"eventId",
    }];
}

- (NSDate *)timestamp {
    double messageTimestampInMicroseconds = [self.eventId doubleValue];
    double messageTimestampInSeconds = messageTimestampInMicroseconds / 1000000;
    return [NSDate dateWithTimeIntervalSince1970:messageTimestampInSeconds];
}
@end
