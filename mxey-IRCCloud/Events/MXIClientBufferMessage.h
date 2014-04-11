//
//  MXIBufferMessage.h
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 02.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/MTLModel.h>
#import <Mantle/MTLJSONAdapter.h>
#import "MXIAbstractClientBufferEvent.h"

@interface MXIClientBufferMessage : MXIAbstractClientBufferEvent
@property(nonatomic) NSString *fromNick;
@property(nonatomic) NSString *message;
@property(nonatomic) NSNumber *highlightsUser;

- (NSDate *)timestamp;
@end
