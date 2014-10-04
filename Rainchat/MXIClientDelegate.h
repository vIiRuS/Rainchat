//
//  MXIClientDelegate.h
//  Rainchat
//
//  Created by Maximilian Gaß on 01.09.13.
//

#import <Foundation/Foundation.h>

@class MXIAbstractClientBufferEvent;
@class MXIClient;

@protocol MXIClientDelegate <NSObject>
- (void)client:(MXIClient *)client didReceiveBufferEvent:(MXIAbstractClientBufferEvent *)bufferMsg;

- (void)clientDidFinishInitialBacklog:(MXIClient *)client;

- (void)clientLostConnection;
@end
