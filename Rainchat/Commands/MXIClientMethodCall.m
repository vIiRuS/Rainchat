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

+ (NSSet *)propertyKeys {
    // Mantle ignores readonly properties, add manually
    NSMutableSet *propertyKeys = [[super propertyKeys] mutableCopy];
    [propertyKeys addObject:@"methodName"];
    return propertyKeys;
}

- (NSString *)methodName {
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return nil;
}

@end
