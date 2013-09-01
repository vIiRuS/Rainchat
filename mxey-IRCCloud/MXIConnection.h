//
//  MXIConnection.h
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 01.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SRWebSocket.h>
#import "MXIConnectionDelegate.h"

@interface MXIConnection : NSObject <SRWebSocketDelegate>
@property (nonatomic) id<MXIConnectionDelegate> delegate;
- initWithEmail:(NSString *)email andPassword:(NSString *)password;
@end
