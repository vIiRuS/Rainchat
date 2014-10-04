//
//  MXIBufferTableCellView.m
//  Rainchat
//
//  Created by viirus on 04/10/14.
//
//

#import "MXIBufferTableCellView.h"

@implementation MXIBufferTableCellView

- (NSTextField *)titleField {
    return [self viewWithTag:1];
}

- (NSTextField *)badge {
    return [ self viewWithTag:2];
}

- (void)setBadgeNumberTo:(NSInteger)number {
    if (number) {
        self.badge.stringValue = [NSString stringWithFormat:@"%ld", (long)number];
        [self.badge.layer setCornerRadius:7.0f];
        self.badge.hidden = NO;
        [self.titleField setTextColor:[NSColor redColor]];
        [self.titleField setFont:[NSFont systemFontOfSize:[[self.titleField.font.fontDescriptor objectForKey:NSFontSizeAttribute] floatValue]]];
    } else {
        self.badge.stringValue = @"";
        self.badge.hidden = YES;
        [self.titleField setTextColor:[NSColor textColor]];
        [self.titleField setFont:[NSFont systemFontOfSize:[[self.titleField.font.fontDescriptor objectForKey:NSFontSizeAttribute] floatValue]]];
    }
}

- (void)setStatusImageForStatus:(MXIClientServerStatus)status {
    // TODO: Implement PartiallyAvailable.. There's a big list of potential statuses:
    // https://github.com/irccloud/irccloud-tools/wiki/API-Stream-Message-Reference#status_changed
    if (status == MXIClientServerStatusConnectedReady) {
        [self.imageView setImage:[NSImage imageNamed:@"NSStatusAvailable"]];
    } else {
        [self.imageView setImage:[NSImage imageNamed:@"NSStatusUnavailable"]];
    }
}

@end
