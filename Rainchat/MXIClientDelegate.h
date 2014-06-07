//
//  MXIClientDelegate.h
//  Rainchat
//
//  Created by Maximilian Gaß on 01.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXIClientBufferMessage.h"

@class MXIClient;

@protocol MXIClientDelegate <NSObject>
- (void)client:(MXIClient *)client didReceiveBufferEvent:(MXIAbstractClientBufferEvent *)bufferMsg;

- (void)clientDidFinishInitialBacklog:(MXIClient *)client;
@end
