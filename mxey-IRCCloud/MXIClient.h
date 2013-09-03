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

@interface MXIClient : NSObject <SRWebSocketDelegate>
@property (nonatomic) id<MXIClientDelegate> delegate;
@property (nonatomic) NSMutableDictionary *connections;
- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password;
@end
