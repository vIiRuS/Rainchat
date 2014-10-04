//
// Created by Maximilian Gaß on 06.04.14.
//

#import "MXIClient.h"
#import "MXIClientUserStats.h"


@implementation MXIClientUserStats
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"highlightStrings" : @"highlights",
        @"lastSelectedBid" : @"last_selected_bid",
    };
}

- (void)processWithClient:(MXIClient *)client {
    client.highlightStrings = self.highlightStrings;
    client.lastSelectedBid = self.lastSelectedBid;
}
@end
