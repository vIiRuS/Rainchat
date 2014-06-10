//
//  MXIClient.m
//  Rainchat
//
//  Created by Maximilian Gaß on 05.09.13.
//

#import "MXIClient.h"
#import "MXIClientBuffer.h"
#import "MXIClientServer.h"
#import "MXIClientUserStats.h"
#import "MXIClientChannel.h"
#import "MXIClientBufferJoin.h"
#import "MXIClientBufferLeave.h"
#import "MXIClientBufferQuit.h"
#import "Events/MXIClientEvent.h"
#import <Mantle/NSValueTransformer+MTLPredefinedTransformerAdditions.h>



@implementation MXIClient

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.transport = [[MXIClientTransport alloc] init];
    self.transport.delegate = self;
    self.servers = [NSMutableDictionary dictionary];
    self.serverOrder = [NSMutableArray array];
    self.buffers = [NSMutableDictionary dictionary];
    return self;
}

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password {
    [self.transport loginWithEmail:email andPassword:password];
}

- (void)transportDidFinishInitialBacklog:(MXIClientTransport *)transport {
    [self.delegate clientDidFinishInitialBacklog:self];
}

- (void)transport:(MXIClientTransport *)transport receivedMessage:(id<MXIClientEvent>)message fromBacklog:(BOOL)fromBacklog {
    [message processWithClient:self];
}

#pragma mark - MXIClientStatus helpers

+ (NSValueTransformer *)statusJSONTransformer {
    NSDictionary *statusDict = @{
                                 @"queued": @(MXIClientStatusQueued),
                                 @"connecting": @(MXIClientStatusConnecting),
                                 @"connected": @(MXIClientStatusConnected),
                                 @"connected_joining": @(MXIClientStatusConnectedJoining),
                                 @"connected_ready": @(MXIClientStatusConnectedReady),
                                 @"quitting": @(MXIClientStatusQuitting),
                                 @"disconnected": @(MXIClientStatusDisconnected),
                                 @"waiting_to_retry": @(MXIClientStatusWaitingToRetry),
                                 @"ip_retry": @(MXIClientStatusIPRetry)};
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:statusDict];
}

+ (NSString*)statusToString:(MXIClientStatus)status {
    switch (status) {
        case MXIClientStatusQueued:
            return @"MXIClientStatusQueued";
        case MXIClientStatusConnecting:
            return @"MXIClientStatusConnecting";
        case MXIClientStatusConnected:
            return @"MXIClientStatusConnected";
        case MXIClientStatusConnectedJoining:
            return @"MXIClientStatusConnectedJoining";
        case MXIClientStatusConnectedReady:
            return @"MXIClientStatusConnectedReady";
        case MXIClientStatusQuitting:
            return @"MXIClientStatusQuitting";
        case MXIClientStatusDisconnected:
            return @"MXIClientStatusDisconnected";
        case MXIClientStatusWaitingToRetry:
            return @"MXIClientStatusWaitingToRetry";
        case MXIClientStatusIPRetry:
            return @"MXIClientStatusIPRetry";
    }
    return @"Unknown";
}

@end
