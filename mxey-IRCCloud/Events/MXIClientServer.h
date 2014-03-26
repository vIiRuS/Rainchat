//
//  MXIClientServer.h
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 02.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
#import "MXIClientBuffer.h"

extern NSString *const MXIClientServerNotification;


@interface MXIClientServer : JSONModel
@property(nonatomic) NSNumber *connectionId;
@property(nonatomic) NSString *name;
@property(nonatomic) NSMutableArray <Ignore> *buffers;
@property(nonatomic) MXIClientBuffer <Ignore> *serverConsoleBuffer;
@end
