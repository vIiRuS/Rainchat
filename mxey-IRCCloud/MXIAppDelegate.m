//
//  MXIAppDelegate.m
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 01.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import "MXIAppDelegate.h"
#import "SRWebSocket.h"
#import "RFKeychain.h"
#import "MXIClientConnection.h"
#import "MXIClientBuffer.h"


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
        MXIClientConnection *connection = item;
        return connection.buffers.count;
    } else {
        return self.client.connectionOrder.count;
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    return [self.client.connectionOrder containsObject:item];
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    if ([self.client.connectionOrder containsObject:item]) {
        NSTableCellView *connectionCellView = [outlineView makeViewWithIdentifier:@"HeaderCell" owner:self];
        MXIClientConnection *connection = item;
        connectionCellView.textField.stringValue = [connection.name uppercaseString];
        return connectionCellView;
    } else {
        NSTableCellView *bufferCellView = [outlineView makeViewWithIdentifier:@"DataCell" owner:self];
        MXIClientBuffer *buffer = item;
        bufferCellView.textField.stringValue = buffer.name;
        return bufferCellView;
    }
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index1 ofItem:(id)item {
    if (item) {
        MXIClientConnection *connection = item;
        return connection.buffers[(NSUInteger) index1];
    } else {
        return self.client.connectionOrder[(NSUInteger) index1];
    }
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    return nil;
}



- (void)client:(MXIClient *)connection didReceiveBufferMsg:(MXIClientBufferMessage *)bufferMsg
{
    NSString *localizedDate = [NSDateFormatter localizedStringFromDate:bufferMsg.timestamp dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
    NSString *output = [NSString stringWithFormat:@"[%@] %@ [%@] %@ <%@> %@\n", bufferMsg.bufferId, localizedDate, bufferMsg.eventId, bufferMsg.channel, bufferMsg.fromNick, bufferMsg.message];
    NSMutableString *text = [self.textView.string mutableCopy];
    [text appendString:output];
    self.textView.string = text;
}

- (void)clientDidFinishInitialBacklog:(MXIClient *)connection
{
    NSMutableString *text = [self.textView.string mutableCopy];
    [text appendString:[connection.connections description]];
    self.textView.string = text;
    [self.sourceListView reloadData];
}




@end
