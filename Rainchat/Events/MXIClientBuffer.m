//
//  MXIClientBuffer.m
//  Rainchat
//
//  Created by Maximilian Gaß on 02.09.13.
//

#import "MXIClientBuffer.h"

#import "MXIClientSayMethodCall.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"
#import "MXIClientServer.h"
#import "MXIClientHeartbeatMethodCall.h"
#import "MXIAbstractClientBufferEvent.h"

@implementation MXIClientBuffer

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"connectionId" : @"cid",
        @"bufferId" : @"bid",
        @"name" : @"name",
        @"isArchived" : @"archived",
        @"type" : @"buffer_type",
        @"lastSeenEid" : @"last_seen_eid"
    };
}

+ (NSValueTransformer *)typeJSONTransformer __unused {
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

- (void)didReceiveBufferEvent:(MXIAbstractClientBufferEvent *)bufferEvent {
    [self.events addObject:bufferEvent];
}

- (void)sendMessageWithString:(NSString *)string {
    MXIClientSayMethodCall *sayMethodCall = [[MXIClientSayMethodCall alloc] init];
    sayMethodCall.connectionId = self.connectionId;
    sayMethodCall.bufferName = self.name;
    sayMethodCall.body = string;
    [self.transport callMethod:sayMethodCall];
}

- (void)processWithClient:(MXIClient *)client {
    MXIClientServer *server = client.servers[self.connectionId];
    if (server && !self.isArchived) {
        [server addBuffer:self];
    }
    client.buffers[self.bufferId] = self;
}

- (void)makeSelected {
    MXIClientHeartbeatMethodCall *heartbeatMethodCall = [[MXIClientHeartbeatMethodCall alloc] init];
    heartbeatMethodCall.selectedBufferId = self.bufferId;
    [self.transport callMethod:heartbeatMethodCall];
    [self markEventSeen:[self.events lastObject]];
    self.numberOfUnreadHighlights = 0;
}

- (void)markEventSeen:(MXIAbstractClientBufferEvent *)lastEvent {
    MXIClientHeartbeatMethodCall *heartbeatMethodCall = [[MXIClientHeartbeatMethodCall alloc] init];
    heartbeatMethodCall.selectedBufferId = self.bufferId;
    if (![self.lastSeenEid isEqualToNumber:lastEvent.eventId]) {
        self.lastSeenEid = lastEvent.eventId;
        [heartbeatMethodCall setLastSeenEids:@{[self.connectionId stringValue ]:
                                                   @{[self.bufferId stringValue]: self.lastSeenEid}
                                               }];
    }
    [self.transport callMethod:heartbeatMethodCall];
}
@end
