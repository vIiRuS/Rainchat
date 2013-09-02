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
- (void)connection:(MXIClient *)connection didReceiveBufferMsg:(MXIClientBufferMessage *)bufferMsg;
- (void)connectionDidFinishBacklog:(MXIClient *)connection;
@end
