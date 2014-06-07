//
// Created by Maximilian Gaß on 26.03.14.
// Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//

#import "MXIClientMethodCall.h"


@implementation MXIClientMethodCall
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"methodName" : @"_method",
        @"requestId" : @"_reqid",
        @"connectionId" : @"cid",
    };
}
@end
