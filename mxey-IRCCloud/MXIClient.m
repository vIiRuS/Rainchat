//
//  MXIClient.m
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 05.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import "MXIClient.h"

@interface MXIClient ()
@property(nonatomic) MXIClientTransport *transport;
@property(nonatomic, strong) NSMutableDictionary *buffers;
@end

@implementation MXIClient

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.transport = [[MXIClientTransport alloc] initWithClient:self];
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
    if ([message isKindOfClass:[MXIClientServer class]]) {
        MXIClientServer *server = (MXIClientServer *) message;
        self.servers[server.connectionId] = server;
        [self.serverOrder addObject:server];
    }

}

@end
