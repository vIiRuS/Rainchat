//
//  MXIConnection.h
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 01.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SRWebSocket.h>

@protocol MXIClientTransportDelegate;


@interface MXIClientTransport : NSObject <SRWebSocketDelegate>
- (id)initWithClient:(id <MXIClientTransportDelegate>)client;

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password;

- (void)loadBacklogFromRelativeURL:(NSString *)relativeURL;

- (void)sendMessage:(NSString *)message toBufferName:(NSString *)bufferName onConnectionId:(NSNumber *)connectionId;
@end
