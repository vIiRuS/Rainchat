//
//  MXIClient.m
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 05.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import "MXIClient.h"
#import "MXIClientServer.h"

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

    self.transport = [[MXIClientTransport alloc] init];
    self.transport.delegate = self;
    self.servers = [NSMutableDictionary dictionary];
    self.serverOrder = [NSMutableArray array];
    self.buffers = [NSMutableDictionary dictionary];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addServer:) name:MXIClientServerNotification object:nil];
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)addServer:(NSNotification *)notification {
    MXIClientServer *server = notification.object;
    self.servers[server.connectionId] = server;
    [self.serverOrder addObject:server];
}

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password {
    [self.transport loginWithEmail:email andPassword:password];
}

- (void)transportDidFinishInitialBacklog:(MXIClientTransport *)transport {
    [self.delegate clientDidFinishInitialBacklog:self];
}

@end
