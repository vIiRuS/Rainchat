//
//  MXIClientServer.m
//  Rainchat
//
//  Created by Maximilian Gaß on 02.09.13.
//

#import "MXIClientServer.h"
#import <Mantle/NSValueTransformer+MTLPredefinedTransformerAdditions.h>

@implementation MXIClientServer
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Woverriding-method-mismatch"
- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError **)err {
    self = [super initWithDictionary:dict error:err];
    if (self) {
        self.buffers = [NSMutableArray array];
    }
    return self;
}
#pragma clang diagnostic pop

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"connectionId" : @"cid",
        @"name" : @"name",
        @"nick" : @"nick",
        @"status": @"status"
    };
}

+ (NSValueTransformer *)statusJSONTransformer __unused {
    NSDictionary *statusDict = @{
        @"queued" : @(MXIClientServerStatusQueued),
        @"connecting" : @(MXIClientServerStatusConnecting),
        @"connected" : @(MXIClientServerStatusConnected),
        @"connected_joining" : @(MXIClientServerStatusConnectedJoining),
        @"connected_ready" : @(MXIClientServerStatusConnectedReady),
        @"quitting" : @(MXIClientServerStatusQuitting),
        @"disconnected" : @(MXIClientServerStatusDisconnected),
        @"waiting_to_retry" : @(MXIClientServerStatusWaitingToRetry),
        @"ip_retry" : @(MXIClientServerStatusIPRetry)};
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:statusDict];
}

- (void)addBuffer:(MXIClientBuffer *)buffer {
    if (buffer.type == MXIClientBufferTypeServerConsole) {
        self.serverConsoleBuffer = buffer;
    } else {
        NSUInteger newIndex = [self.buffers indexOfObject:buffer
                                     inSortedRange:(NSRange){0, [self.buffers count]}
                                           options:NSBinarySearchingInsertionIndex
                                          usingComparator:^(id buffer1, id buffer2) {
                                              NSString *buffer1Name = [buffer1 valueForKey:@"name"];
                                              NSString *buffer2Name = [buffer2 valueForKey:@"name"];
                                              return (NSComparisonResult)[buffer1Name compare:buffer2Name];
                                          }];
        [self.buffers insertObject:buffer atIndex:newIndex];
    }
}

- (void)processWithClient:(MXIClient *)client {
    client.servers[self.connectionId] = self;
    [client.serverOrder addObject:self];
}

@end
