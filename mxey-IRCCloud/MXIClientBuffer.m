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
        @"bid" : @"bufferId",
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

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError **)err {
    self = [super initWithDictionary:dict error:err];
    if (self) {
        self.events = [NSMutableArray array];
    }

    return self;
}

- (void)didReceiveBufferMessage:(MXIClientBufferMessage *)bufferMessage {
    [self.events addObject:bufferMessage];
}

- (void)sendMessageWithString:(NSString *)string {
    [self.client sendMessage:string toBufferName:self.name onConnectionId:self.connectionId];
}
@end
