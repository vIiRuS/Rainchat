//
//  MXIClientBuffer.m
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 02.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import "MXIClientBuffer.h"

@implementation MXIClientBuffer
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
        @"cid" : @"connectionId",
        @"name" : @"name",
        @"archived" : @"isArchived",
        @"buffer_type" : @"type",
    }];
}

- (void)setTypeWithNSString:(NSString *)typeString {
    NSDictionary *bufferTypes = @{
        @"console" : @(MXIClientBufferTypeServerConsole),
        @"channel" : @(MXIClientBufferTypeChannel),
        @"conversation" : @(MXIClientBufferTypeConversation),
    };
    self.type = (MXIClientBufferType) [bufferTypes[typeString] integerValue];
}

@end
