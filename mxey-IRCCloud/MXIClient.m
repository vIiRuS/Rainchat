//
//  MXIClient.m
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 05.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import "MXIClient.h"
#import "MXIClientBuffer.h"
#import "MXIClientServer.h"
#import "MXIClientUserStats.h"

@interface MXIClient ()
@property(nonatomic) MXIClientTransport *transport;
@property(nonatomic, strong) NSArray *highlightStrings;
@end

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

- (void)transport:(MXIClientTransport *)transport receivedMessage:(id)message fromBacklog:(BOOL)fromBacklog {
    if ([message isKindOfClass:[MXIAbstractClientBufferEvent class]]) {
        MXIAbstractClientBufferEvent *bufferEvent = (MXIAbstractClientBufferEvent *) message;
        MXIClientBuffer *buffer = self.buffers[bufferEvent.bufferId];
        if (!buffer) {
            NSLog(@"Received buffer event for non-existent buffer: %@", bufferEvent.bufferId);
            return;
        }
        [bufferEvent checkForHighlights:self.highlightStrings];

        [self.delegate client:self didReceiveBufferEvent:bufferEvent];
        [buffer didReceiveBufferEvent:bufferEvent];
    }
    else if ([message isKindOfClass:[MXIClientServer class]]) {
        MXIClientServer *server = (MXIClientServer *) message;
        self.servers[server.connectionId] = server;
        [self.serverOrder addObject:server];
    }
    else if ([message isKindOfClass:[MXIClientBuffer class]]) {
        MXIClientBuffer *buffer = (MXIClientBuffer *) message;
        MXIClientServer *server = self.servers[buffer.connectionId];
        if (server && !buffer.isArchived) {
            [server addBuffer:buffer];
        }
        self.buffers[buffer.bufferId] = buffer;
    }
    else if ([message isKindOfClass:[MXIClientUserStats class]]) {
        MXIClientUserStats *userStats = message;
        self.highlightStrings = userStats.highlightStrings;
    }

}


@end
