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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addBuffer:) name:MXIClientBufferNotification object:nil];

    }
    return self;
}
#pragma clang diagnostic pop

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
        @"cid" : @"connectionId",
        @"name" : @"name",
        @"nick" : @"nick",
        @"order" : @"order",
    }];
}

- (void)addBuffer:(NSNotification *)notification {
    MXIClientBuffer *buffer = notification.object;
    if ([buffer.connectionId isEqualToNumber:self.connectionId] && !buffer.isArchived) {
        if (buffer.type == MXIClientBufferTypeServerConsole) {
            self.serverConsoleBuffer = buffer;
        } else {
            [self.buffers addObject:buffer];
        }
    }
}

@end
