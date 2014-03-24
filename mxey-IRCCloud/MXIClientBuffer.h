//
//  MXIClientBuffer.h
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 02.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
#import "MXIClient.h"
#import "MXIClientBufferMessage.h"

typedef NS_ENUM(NSInteger, MXIClientBufferType) {
    MXIClientBufferTypeServerConsole,
    MXIClientBufferTypeChannel,
    MXIClientBufferTypeConversation,
};


@interface MXIClientBuffer : JSONModel
@property(nonatomic) NSNumber *connectionId;
@property(nonatomic) NSNumber *bufferId;
@property(nonatomic) NSString *name;
@property(nonatomic) BOOL isArchived;
@property(nonatomic) MXIClientBufferType type;
@property(nonatomic, strong) NSMutableArray <Ignore> *events;
@property(nonatomic) MXIClient <Ignore> *client;

- (void)didReceiveBufferMessage:(MXIClientBufferMessage *)bufferMessage;

- (void)sendMessageWithString:(NSString *)string;
@end
