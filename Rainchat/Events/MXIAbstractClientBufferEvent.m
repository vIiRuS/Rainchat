//
// Created by Maximilian Gaß on 11.04.14.
//

#import "MXIAbstractClientBufferEvent.h"
#import "MTLValueTransformer.h"
#import "MXIClientServer.h"

@implementation MXIAbstractClientBufferEvent {

}
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"connectionId" : @"cid",
        @"bufferId" : @"bid",
        @"eventId" : @"eid",
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
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2;
    NSMutableDictionary *stringAttributes = [@{
        NSFontAttributeName : [NSFont fontWithName:@"HelveticaNeue" size:14],
        NSForegroundColorAttributeName : [NSColor blackColor],
        NSParagraphStyleAttributeName : paragraphStyle,
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

- (NSString *)renderToHtmlString {
    NSString *stringWithTimestamp = [NSString stringWithFormat:@"<li><span class='timestamp'>%@</span><span>%@</span></li>", self.formattedTimestamp, self.string];
    return stringWithTimestamp;
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

    // Make sure we don't hilight ourselves.
    if (![server.nick isEqualToString:self.fromNick]) {
        [self checkForHighlights:highlightStrings];
    }
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
