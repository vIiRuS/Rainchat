//
// Created by Maximilian Gaß on 26.03.14.
// Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//

#import "MXIClientSayMethodCall.h"


@implementation MXIClientSayMethodCall
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"methodName" : @"_method",
        @"requestId" : @"_reqid",
        @"connectionId" : @"cid",
        @"bufferName" : @"to",
        @"message" : @"msg",
    };
}

- (id)init {
    self = [super init];
    if (self) {
        self.methodName = @"say";
    }

    return self;
}

@end
