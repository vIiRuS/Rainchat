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
@class MXIClientMethodCall;


@interface MXIClientTransport : NSObject <SRWebSocketDelegate>
@property(nonatomic) id <MXIClientTransportDelegate> delegate;

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password;

- (void)loadBacklogFromRelativeURL:(NSString *)relativeURL;

- (void)callMethod:(MXIClientMethodCall *)methodCall;
@end
