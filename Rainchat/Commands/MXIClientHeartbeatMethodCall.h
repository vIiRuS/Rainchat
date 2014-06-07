//
//  MXIClientHeartbeatMethodCall.h
//  Rainchat
//
//  Created by Phillip on 05/06/14.
//  Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//

#import "MXIClientMethodCall.h"

@interface MXIClientHeartbeatMethodCall : MXIClientMethodCall

@property(nonatomic) NSNumber *selectedBuffer;
@property(nonatomic) NSString *seenEids;

-(void)setLastSeenEids:(NSDictionary*) dictionary;

@end
