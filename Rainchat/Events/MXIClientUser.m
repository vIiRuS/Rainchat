//
//  MXIClientUser.m
//  Rainchat
//
//  Created by Phillip Thelen on 04/06/14.
//

#import "MXIClientUser.h"
#import "MTLValueTransformer.h"

@implementation MXIClientUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"nick" : @"nick",
             @"realName" : @"realname",
             @"ircServer" : @"ircserver",
             @"mode" : @"mode",
             @"away" : @"away"
             };
}

+ (NSValueTransformer *)awayJSONTransformer __unused {
    return [MTLValueTransformer transformerWithBlock:^id(id o) {
        double messageTimestampInMicroseconds = [o doubleValue];
        double messageTimestampInSeconds = messageTimestampInMicroseconds / 1000000;
        return [NSDate dateWithTimeIntervalSince1970:messageTimestampInSeconds];
    }];
}

+(id)newUserWithNick:(NSString *)nick {
    MXIClientUser *newUser = [[MXIClientUser alloc] init];
    newUser.nick = nick;
    return newUser;
}

@end
