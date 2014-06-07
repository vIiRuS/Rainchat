//
// Created by Maximilian Gaß on 26.03.14.
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
