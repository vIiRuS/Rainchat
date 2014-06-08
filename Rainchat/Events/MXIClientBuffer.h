//
//  MXIClientBuffer.h
//  Rainchat
//
//  Created by Maximilian Gaß on 02.09.13.
//

#import <Foundation/Foundation.h>
#import <Mantle/MTLModel.h>
#import <Mantle/MTLJSONAdapter.h>
#import "MXIClient.h"
#import "MXIClientChannel.h"
#import "MXIClientTransport.h"
#import "MXIClientEvent.h"
@class MXIAbstractClientBufferEvent;

typedef NS_ENUM(NSInteger, MXIClientBufferType) {
    MXIClientBufferTypeServerConsole,
    MXIClientBufferTypeChannel,
    MXIClientBufferTypeConversation,
};


@interface MXIClientBuffer : MTLModel <MTLJSONSerializing, MXIClientEvent>
@property(nonatomic) NSNumber *connectionId;
@property(nonatomic) NSNumber *bufferId;
@property(nonatomic) NSString *name;
@property(nonatomic) BOOL isArchived;
@property(nonatomic) MXIClientBufferType type;
@property(nonatomic, strong) NSMutableArray *events;
@property(nonatomic) MXIClientTransport *transport;
@property(nonatomic) MXIClientChannel *channel;

@property(nonatomic) NSNumber *lastSeenEid;

- (void)didReceiveBufferEvent:(MXIAbstractClientBufferEvent *)bufferEvent;
- (void)sendMessageWithString:(NSString *)string;
- (void)sendHeartbeatWithLastSeenEvent:(MXIAbstractClientBufferEvent *)bufferEvent;
- (void)sendHeartbeat;
@end
