//
//  MXIClientServer.m
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 02.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import "MXIClientServer.h"
#import "MXIClientBuffer.h"

@implementation MXIClientServer
- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    self = [super initWithDictionary:dict error:err];
    if (self) {
        self.buffers = [NSMutableArray array];
    }
    return self;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
        @"cid": @"connectionId",
        @"name": @"name",
        @"nick": @"nick",
        @"order": @"order",
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