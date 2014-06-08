//
//  MXIClientHeartbeatMethodCall.h
//  Rainchat
//
//  Created by Phillip on 05/06/14.
//

#import "MXIClientMethodCall.h"

@interface MXIClientHeartbeatMethodCall : MXIClientMethodCall

@property(nonatomic) NSNumber *selectedBufferId;
@property(nonatomic) NSString *seenEids;

-(void)setLastSeenEids:(NSDictionary*) dictionary;

@end
