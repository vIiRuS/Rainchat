//
//  MXIConnection.h
//  Rainchat
//
//  Created by Maximilian Gaß on 01.09.13.
//

#import <Foundation/Foundation.h>
#import <SRWebSocket.h>

@protocol MXIClientTransportDelegate;
@class MXIClientMethodCall;


@interface MXIClientTransport : NSObject <SRWebSocketDelegate>
@property(nonatomic) id <MXIClientTransportDelegate> delegate;

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password;

- (void)loadBacklogFromRelativeURL:(NSString *)relativeURL;

- (void)callMethod:(MXIClientMethodCall *)methodCall;
@end
