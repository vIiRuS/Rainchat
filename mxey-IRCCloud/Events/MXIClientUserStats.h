//
//  MXIClientUserStats.h
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 27.03.14.
//  Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//

#import "JSONModel.h"

extern NSString *const MXIClientUserStatsNotification;

@interface MXIClientUserStats : JSONModel
@property(nonatomic) NSArray *highlights;
@end
