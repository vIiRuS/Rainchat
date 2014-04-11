//
// Created by Maximilian Gaß on 11.04.14.
// Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//

#import "MXIClientBufferMessage.h"


@implementation MXIAbstractClientBufferEvent {

}
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"connectionId" : @"cid",
        @"bufferId" : @"bid",
        @"eventId" : @"eid",
    };
}
@end
