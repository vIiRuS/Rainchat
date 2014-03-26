//
// Created by Maximilian Gaß on 26.03.14.
// Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//

#import "MXIClientSayMethodCall.h"


@implementation MXIClientSayMethodCall
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
        @"_method" : @"methodName",
        @"_reqid" : @"requestId",
        @"cid" : @"connectionId",
        @"to" : @"bufferName",
        @"msg" : @"message",
    }];
}

- (id)init {
    self = [super init];
    if (self) {
        self.methodName = @"say";
    }

    return self;
}

@end
