//
//  MXIConnectionDelegate.h
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 01.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MXIConnection;

@protocol MXIConnectionDelegate <NSObject>
- (void)connection:(MXIConnection *)connection DidReceiveBufferMsg:(NSDictionary *)bufferMsg;
@end
