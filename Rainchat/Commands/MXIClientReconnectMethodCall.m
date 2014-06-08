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

- (NSString *)methodName {
    return @"reconnect";
}
@end
