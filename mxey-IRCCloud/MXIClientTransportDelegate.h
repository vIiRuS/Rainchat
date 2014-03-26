//
// Created by Maximilian Gaß on 23.03.14.
// Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MXIClientTransport;

@protocol MXIClientTransportDelegate <NSObject>
- (void)transport:(MXIClientTransport *)transport receivedMessage:(id)message fromBacklog:(BOOL)fromBacklog;

- (void)transportDidFinishInitialBacklog:(MXIClientTransport *)transport;
@end
