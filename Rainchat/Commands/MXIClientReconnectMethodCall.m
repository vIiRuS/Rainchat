//
//  MXIClientReconnectMethodCall.m
//  Rainchat
//
//  Created by Thomas Roth on 08/06/14.
//

#import "MXIClientReconnectMethodCall.h"
#import "NSDictionary+MTLManipulationAdditions.h"

@implementation MXIClientReconnectMethodCall
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *mapping = @{@"cid": @"connectionId"};
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

- (id)init {
    self = [super init];
    if (self) {
        self.methodName = @"reconnect";
    }

    return self;
}

@end
