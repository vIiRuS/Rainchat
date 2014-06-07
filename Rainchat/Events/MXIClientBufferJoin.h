//
//  MXIClientBufferJoin.h
//  Rainchat
//
//  Created by Phillip on 05/06/14.
//  Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//

#import "MXIAbstractClientBufferEvent.h"

@interface MXIClientBufferJoin : MXIAbstractClientBufferEvent

@property(nonatomic) NSString *fromNick;
@property(nonatomic) NSString *channelName;

- (NSString *)string;

@end
