//
//  MXIBufferMessage.h
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 02.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

@interface MXIClientBufferMessage : JSONModel
@property (nonatomic) NSString *channel;
@property (nonatomic) NSString *fromNick;
@property (nonatomic) NSString *message;
@property (nonatomic) NSNumber *eventId;
@property (nonatomic) NSNumber *bufferId;
- (NSDate *)timestamp;
@end
