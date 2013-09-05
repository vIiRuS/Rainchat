//
//  MXIConnection.h
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 01.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SRWebSocket.h>
#import "MXIClientDelegate.h"

@class MXIClient;

@interface MXIClientTransport : NSObject <SRWebSocketDelegate>
- (id)initWithClient:(MXIClient *)client;
- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password;
- (void)loadBacklogFromRelativeURL:(NSString *)relativeURL;
@end
