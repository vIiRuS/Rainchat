//
//  MXIClientBufferLeave.h
//  mxey-IRCCloud
//
//  Created by Phillip on 05/06/14.
//  Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//

#import "MXIAbstractClientBufferEvent.h"

@interface MXIClientBufferLeave : MXIAbstractClientBufferEvent

@property(nonatomic) NSString *fromNick;
@property(nonatomic) NSString *message;
@property(nonatomic) NSString *channelName;

- (NSString *)string;

@end
