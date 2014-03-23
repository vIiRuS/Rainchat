//
//  MXIAppDelegate.m
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 01.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import "MXIAppDelegate.h"
#import "RFKeychain.h"
#import "MXIClientServer.h"


@implementation MXIAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSString *account = @"mxey@mxey.net";
    NSString *password = [RFKeychain passwordForAccount:account service:@"IRCCloud"];
    self.client = [[MXIClient alloc] init];
    self.client.delegate = self;
    [self.client loginWithEmail:account andPassword:password];
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    if (item) {
        MXIClientServer *server = item;
        return server.buffers.count;
    } else {
        return self.client.serverOrder.count;
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    return [self.client.serverOrder containsObject:item];
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    if ([self.client.serverOrder containsObject:item]) {
        NSTableCellView *serverCellView = [outlineView makeViewWithIdentifier:@"HeaderCell" owner:self];
        MXIClientServer *server = item;
        serverCellView.textField.stringValue = [server.name uppercaseString];
        return serverCellView;
    } else {
        NSTableCellView *bufferCellView = [outlineView makeViewWithIdentifier:@"DataCell" owner:self];
        MXIClientBuffer *buffer = item;
        bufferCellView.textField.stringValue = buffer.name;
        return bufferCellView;
    }
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index1 ofItem:(id)item {
    if (item) {
        MXIClientServer *server = item;
        return server.buffers[(NSUInteger) index1];
    } else {
        return self.client.serverOrder[(NSUInteger) index1];
    }
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    return nil;
}


- (void)client:(MXIClient *)client didReceiveBufferMsg:(MXIClientBufferMessage *)bufferMsg {
    NSString *output = [self formatBufferMessage:bufferMsg];
    NSMutableString *text = [self.textView.string mutableCopy];
    [text appendString:output];
    self.textView.string = text;
}

- (NSString *)formatBufferMessage:(MXIClientBufferMessage *)bufferMessage {
    NSString *localizedDate = [NSDateFormatter localizedStringFromDate:bufferMessage.timestamp dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
    NSString *output = [NSString stringWithFormat:@" %@ <%@> %@\n", localizedDate, bufferMessage.fromNick, bufferMessage.message];
    return output;
}

- (void)clientDidFinishInitialBacklog:(MXIClient *)client {
    NSMutableString *text = [self.textView.string mutableCopy];
    [text appendString:[client.servers description]];
    self.textView.string = text;
    [self.sourceListView reloadData];
}


- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    MXIClientBuffer *selectedBuffer = [self getSelectedBuffer];
    if (selectedBuffer) {
        NSMutableString *bufferText = [NSMutableString string];
        for (MXIClientBufferMessage *bufferMessage in selectedBuffer.events) {
            [bufferText appendString:[self formatBufferMessage:bufferMessage]];
        }
        self.textView.string = bufferText;
        [self.textView scrollToEndOfDocument:self];
    }
}

- (MXIClientBuffer *)getSelectedBuffer {
    if (self.sourceListView.selectedRow == -1) {
        return nil;
    }

    NSObject *item = [self.sourceListView itemAtRow:self.sourceListView.selectedRow];
    MXIClientBuffer *selectedBuffer;
    if ([item isKindOfClass:[MXIClientServer class]]) {
        MXIClientServer *server = (MXIClientServer *) item;
        selectedBuffer = server.serverConsoleBuffer;
    } else {
        selectedBuffer = (MXIClientBuffer *) item;
    }
    return selectedBuffer;
}


@end
