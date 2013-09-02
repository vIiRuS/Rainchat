//
//  MXIConnectionDelegate.h
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 01.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXIBufferMessage.h"

@class MXIConnection;

@protocol MXIConnectionDelegate <NSObject>
- (void)connection:(MXIConnection *)connection didReceiveBufferMsg:(MXIBufferMessage *)bufferMsg;
@end
