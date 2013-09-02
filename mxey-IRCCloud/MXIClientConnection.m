//
//  MXIClientConnection.m
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 02.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import "MXIClientConnection.h"

@implementation MXIClientConnection
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
        @"cid": @"connectionId",
        @"name": @"name",
        @"nick": @"nick",
    }];
}

@end
