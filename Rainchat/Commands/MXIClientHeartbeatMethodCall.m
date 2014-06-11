//
//  MXIClientHeartbeatMethodCall.m
//  Rainchat
//
//  Created by Phillip on 05/06/14.
//

#import "MXIClientHeartbeatMethodCall.h"
#import "NSDictionary+MTLManipulationAdditions.h"

@implementation MXIClientHeartbeatMethodCall

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:@{
        @"selectedBufferId" : @"selectedBuffer",
        @"seenEids" : @"seenEids",
    }];
}

- (void)setLastSeenEids:(NSDictionary *)dictionary {
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    self.seenEids = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)methodName {
    return @"heartbeat";
}


- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *modifiedDictionaryValue = [[super dictionaryValue] mutableCopy];

    for (NSString *originalKey in [super dictionaryValue]) {
        if ([self valueForKey:originalKey] == nil) {
            [modifiedDictionaryValue removeObjectForKey:originalKey];
        }
    }

    return [modifiedDictionaryValue copy];
}

@end
