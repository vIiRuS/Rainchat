//
// Created by Maximilian Gaß on 23.03.14.
//

#import <Foundation/Foundation.h>

@class MXIClientTransport;

@protocol MXIClientTransportDelegate <NSObject>
- (void)transport:(MXIClientTransport *)transport receivedMessage:(id)message fromBacklog:(BOOL)fromBacklog;

- (void)transportDidFinishInitialBacklog:(MXIClientTransport *)transport;

- (void)transportLostConnection;
@end
