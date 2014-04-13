//
// Created by Maximilian Gaß on 11.04.14.
// Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//

#import "MXIAppDelegate.h"
#import "MTLValueTransformer.h"


@interface MXIAbstractClientBufferEvent ()
- (NSString *)formattedTimestamp;

- (NSString *)string;
@end

@implementation MXIAbstractClientBufferEvent {

}
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"connectionId" : @"cid",
        @"bufferId" : @"bid",
        @"timestamp" : @"eid",
    };
}

+ (NSValueTransformer *)timestampJSONTransformer __unused {
    return [MTLValueTransformer transformerWithBlock:^id(id o) {
        double messageTimestampInMicroseconds = [o doubleValue];
        double messageTimestampInSeconds = messageTimestampInMicroseconds / 1000000;
        return [NSDate dateWithTimeIntervalSince1970:messageTimestampInSeconds];
    }];
}

- (NSMutableDictionary *)stringAttributes {
    return [@{
        NSFontAttributeName : [NSFont systemFontOfSize:13],
        NSForegroundColorAttributeName : [NSColor blackColor],
    } mutableCopy];
}

- (NSString *)formattedTimestamp {
    return [NSDateFormatter localizedStringFromDate:self.timestamp dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle];
}

- (NSAttributedString *)renderToAttributedString {
    NSString *stringWithTimestamp = [NSString stringWithFormat:@"%@ %@\n", self.formattedTimestamp, self.string];
    return [[NSAttributedString alloc] initWithString:stringWithTimestamp attributes:self.stringAttributes];
}

- (NSString *)string {
    return @"MXIAbstractClientBufferEvent: string method needs to be overriden";
}

@end
