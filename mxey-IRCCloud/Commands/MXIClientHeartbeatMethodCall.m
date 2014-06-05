//
//  MXIClientHeartbeatMethodCall.m
//  mxey-IRCCloud
//
//  Created by Phillip on 05/06/14.
//  Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//

#import "MXIClientHeartbeatMethodCall.h"
#import "NSDictionary+MTLManipulationAdditions.h"
#import "MTLValueTransformer.h"

@implementation MXIClientHeartbeatMethodCall

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:@{
        @"selectedBuffer" : @"selectedBuffer",
        @"seenEids" : @"seenEids",
    }];
}

-(void)setLastSeenEids:(NSDictionary*)dictionary {
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    self.seenEids = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (id)init {
    self = [super init];
    if (self) {
        self.methodName = @"heartbeat";
    }
    
    return self;
}

@end
