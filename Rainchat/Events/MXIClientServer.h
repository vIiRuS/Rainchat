//
//  MXIClientServer.h
//  Rainchat
//
//  Created by Maximilian Gaß on 02.09.13.
//

#import <Foundation/Foundation.h>
#import "MXIClient.h"
#import "MXIClientBuffer.h"
#import "MXIClientEvent.h"

@interface MXIClientServer : MTLModel <MTLJSONSerializing, MXIClientEvent>
@property(nonatomic) NSNumber *connectionId;
@property(nonatomic) NSString *name;
@property(nonatomic) NSString *nick;
@property(nonatomic) MXIClientServerStatus status;

@property(nonatomic) MXIClientTransport *transport;
@property(nonatomic) NSMutableArray *buffers;
@property(nonatomic) MXIClientBuffer *serverConsoleBuffer;

- (void)addBuffer:(MXIClientBuffer *)buffer;
@end
