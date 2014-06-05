//
//  MXIClientChannel.h
//  mxey-IRCCloud
//
//  Created by Phillip Thelen on 04/06/14.
//  Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/MTLJSONAdapter.h>

@interface MXIClientChannel : MTLModel <MTLJSONSerializing>

@property(nonatomic) NSNumber *connectionId;
@property(nonatomic) NSNumber *bufferId;
@property(nonatomic) NSString *channelMode;
@property(nonatomic) NSString *channelType;
@property(nonatomic) NSString *topicText;
@property(nonatomic) NSDate *topicChanged;
@property(nonatomic) NSString *topicNick;
@property(nonatomic) NSMutableArray *members;

-(void)removeUserWithNick:(NSString*)nick;
-(void)insertUserWithNick:(NSString*)nick;

@end
