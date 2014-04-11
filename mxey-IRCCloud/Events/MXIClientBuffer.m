//
//  MXIClientBuffer.m
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 02.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import "MXIClientBuffer.h"

#import "MXIClientSayMethodCall.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"

@implementation MXIClientBuffer

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"connectionId" : @"cid",
        @"bufferId" : @"bid",
        @"name" : @"name",
        @"isArchived" : @"archived",
        @"type" : @"buffer_type",
    };
}

+ (NSValueTransformer *)typeJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
        @"console" : @(MXIClientBufferTypeServerConsole),
        @"channel" : @(MXIClientBufferTypeChannel),
        @"conversation" : @(MXIClientBufferTypeConversation),
    }];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.events = [NSMutableArray array];
    }

    return self;
}

- (void)didReceiveBufferMessage:(MXIClientBufferMessage *)bufferMessage {
    [self.events addObject:bufferMessage];
}

- (void)sendMessageWithString:(NSString *)string {
    MXIClientSayMethodCall *sayMethodCall = [[MXIClientSayMethodCall alloc] init];
    sayMethodCall.connectionId = self.connectionId;
    sayMethodCall.bufferName = self.name;
    sayMethodCall.body = string;
    [self.transport callMethod:sayMethodCall];
}

@end
