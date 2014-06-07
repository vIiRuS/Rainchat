//
// Created by Maximilian Gaß on 11.04.14.
// Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//

#import "MXIAbstractClientBufferEvent.h"
#import "MXIAppDelegate.h"
#import "MTLValueTransformer.h"
#import "MXIClientBuffer.h"
#import "MXIClientServer.h"

@interface MXIAbstractClientBufferEvent ()
- (NSString *)formattedTimestamp;

@end

@implementation MXIAbstractClientBufferEvent {

}
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"connectionId" : @"cid",
        @"bufferId" : @"bid",
        @"eventId": @"eid",
        // eid is converted into an NSDate in timestampJSONTransformer
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
    NSMutableDictionary *stringAttributes = [@{
        NSFontAttributeName : [NSFont fontWithName:@"HelveticaNeue" size:14],
        NSForegroundColorAttributeName : [NSColor blackColor],
    } mutableCopy];
    if (self.highlightsUser.boolValue) {
        stringAttributes[NSForegroundColorAttributeName] = [NSColor redColor];
    }
    return stringAttributes;
}

- (NSString *)formattedTimestamp {
    return [NSDateFormatter localizedStringFromDate:self.timestamp dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle];
}

- (NSAttributedString *)renderToAttributedString {
    NSString *stringWithTimestamp = [NSString stringWithFormat:@"%@ %@\n", self.formattedTimestamp, self.string];
    return [[NSAttributedString alloc] initWithString:stringWithTimestamp attributes:self.stringAttributes];
}

- (void)checkForHighlights:(NSArray *)highlightStrings {
    self.highlightsUser = @NO;
}


- (NSString *)string {
    return @"MXIAbstractClientBufferEvent: string method needs to be overriden";
}

- (void)processWithClient:(MXIClient *)client buffer:(MXIClientBuffer *)buffer {
    MXIClientServer *server = client.servers[buffer.connectionId];
    
    NSMutableArray *highlightStrings = [[NSMutableArray alloc] initWithArray:client.highlightStrings];
    [highlightStrings addObject:server.nick];
    [self checkForHighlights:highlightStrings];
}

- (void)processWithClient:(MXIClient *)client {
    MXIClientBuffer *buffer = client.buffers[self.bufferId];
    if (!buffer) {
        NSLog(@"Received buffer event for non-existent buffer: %@", self.bufferId);
        return;
    }
    
    [self processWithClient:client buffer:buffer];
    [buffer didReceiveBufferEvent:self];
    [client.delegate client:client didReceiveBufferEvent:self];
}
@end
