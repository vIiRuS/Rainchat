//
// Created by Maximilian Gaß on 26.03.14.
//

#import "MXIClientSayMethodCall.h"
#import "NSDictionary+MTLManipulationAdditions.h"


@implementation MXIClientSayMethodCall
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:@{
        @"bufferName" : @"to",
        @"body" : @"msg",
    }];
}

- (NSString *)methodName {
    return @"say";
}


@end
