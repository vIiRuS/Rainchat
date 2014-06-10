//
//  MXIClient.m
//  Rainchat
//
//  Created by Maximilian Gaß on 05.09.13.
//

#import "MXIClient.h"
#import "MXIClientBuffer.h"
#import "MXIClientBufferJoin.h"


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

- (void)transport:(MXIClientTransport *)transport receivedMessage:(id <MXIClientEvent>)message fromBacklog:(BOOL)fromBacklog {
    [message processWithClient:self];
}

@end
