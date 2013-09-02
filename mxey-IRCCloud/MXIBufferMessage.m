//
//  MXIBufferMessage.m
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 02.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import "MXIBufferMessage.h"

@implementation MXIBufferMessage

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
        @"chan": @"channel",
        @"msg": @"message",
        @"from": @"fromNick",
        @"bid": @"bufferId",
        @"eid": @"eventId",
    }];
}

- (NSDate *)timestamp
{
    double messageTimestampInMicroseconds = [self.eventId doubleValue];
    double messageTimestampInSeconds = messageTimestampInMicroseconds / 1000000;
    return [NSDate dateWithTimeIntervalSince1970:messageTimestampInSeconds];
}
@end
