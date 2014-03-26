//
//  MXIClientServer.m
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 02.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import "MXIClientServer.h"

@implementation MXIClientServer
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Woverriding-method-mismatch"
- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError **)err {
    self = [super initWithDictionary:dict error:err];
    if (self) {
        self.buffers = [NSMutableArray array];
    }
    return self;
}
#pragma clang diagnostic pop

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
        @"cid" : @"connectionId",
        @"name" : @"name",
        @"nick" : @"nick",
        @"order" : @"order",
    }];
}

- (void)addBuffer:(MXIClientBuffer *)buffer {
    if (buffer.type == MXIClientBufferTypeServerConsole) {
        self.serverConsoleBuffer = buffer;
    } else {
        [self.buffers addObject:buffer];
    }
}

@end
