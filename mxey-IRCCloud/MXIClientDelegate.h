//
//  MXIClientDelegate.h
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 01.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXIClientBufferMessage.h"

@class MXIClient;

@protocol MXIClientDelegate <NSObject>
- (void)client:(MXIClient *)connection didReceiveBufferMsg:(MXIClientBufferMessage *)bufferMsg;
- (void)clientDidFinishBacklog:(MXIClient *)connection;
@end
