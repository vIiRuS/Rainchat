//
//  MXIChatWindowController.m
//  Rainchat
//
//  Created by Thomas Roth on 07/06/14.
//

#import "MXIChatWindowController.h"
#import "RFKeychain.h"
#import "MXIClientBuffer.h"
#import "MXIClientBufferJoin.h"
#import "MXIClientBufferLeave.h"
#import "MXIClientBufferMessage.h"
#import "MXIClientServer.h"
#import "MXIClientUser.h"
#import "MXILoginSheetController.h"
#import "MXIClientBufferQuit.h"
#import "MXIBufferTableCellView.h"

@interface MXIChatWindowController ()
@property(nonatomic) BOOL backlogFinished;
@property(nonatomic, readonly) MXIClientBuffer *selectedBuffer;
@property(nonatomic, strong) MXILoginSheetController *sheetController;
@end

@implementation MXIChatWindowController

#pragma mark - MXIChatWindowController

- (id)initWithWindow:(NSWindow *)window {
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    if (self.userAccount && self.userPassword) {
        [self login];
    } else {
        [self presentLoginSheet];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:NSApplicationDidBecomeActiveNotification
                                               object:[NSApplication sharedApplication]];
}

// TODO: This should probably be in a model
- (NSString *)userAccount {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"userAccount"];
}

- (void)setUserAccount:(NSString *)userAccount {
    [[NSUserDefaults standardUserDefaults] setObject:userAccount forKey:@"userAccount"];
}

- (NSString *)userPassword {
    return [RFKeychain passwordForAccount:[self userAccount] service:@"Rainchat"];
}

- (void)setUserPassword:(NSString *)userPassword {
    [RFKeychain setPassword:userPassword account:self.userAccount service:@"Rainchat"];
}

- (void)presentLoginSheet {
    NSLog(@"Present login");
    self.sheetController = [[MXILoginSheetController alloc] init];
    [self.window beginSheet:self.sheetController.window completionHandler:^(NSModalResponse returnCode) {
        self.userAccount = self.sheetController.account;
        self.userPassword = self.sheetController.password;
        [self login];
    }];
}

- (void)login {
    NSLog(@"Logging in");
    self.client = [[MXIClient alloc] init];
    self.client.delegate = self;
    [self.client loginWithEmail:self.userAccount andPassword:self.userPassword];
}

- (MXIClientBuffer *)selectedBuffer {
    if (self.buffersOutlineView.selectedRow == -1) {
        return nil;
    }

    NSObject *item = [self.buffersOutlineView itemAtRow:self.buffersOutlineView.selectedRow];
    MXIClientBuffer *selectedBuffer;
    if ([item isKindOfClass:[MXIClientServer class]]) {
        MXIClientServer *server = (MXIClientServer *) item;
        selectedBuffer = server.serverConsoleBuffer;
    } else {
        selectedBuffer = (MXIClientBuffer *) item;
    }
    return selectedBuffer;
}

- (void)displayUserNotificationForEvent:(MXIAbstractClientBufferEvent *)bufferEvent {
    MXIClientBuffer *buffer = self.client.buffers[bufferEvent.bufferId];
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = buffer.name;
    notification.informativeText = bufferEvent.string;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

- (void)focusMessageTextField {
    [self.window makeFirstResponder:self.messageTextView];
    self.messageTextView.selectedRange = NSMakeRange(self.messageTextView.string.length, 0);
}

- (void)updateDockTile {
    NSInteger numberOfUnreadHighlights = 0;
    for (MXIClientBuffer *buffer in [self.client.buffers allValues]) {
        if (buffer.numberOfUnreadHighlights) {
            numberOfUnreadHighlights = numberOfUnreadHighlights + buffer.numberOfUnreadHighlights;
        }
    }
    NSDockTile *dockTile = [[NSApplication sharedApplication] dockTile];
    if (numberOfUnreadHighlights) {
        [dockTile setBadgeLabel:[NSString stringWithFormat:@"%ld", numberOfUnreadHighlights]];
    } else {
        [dockTile setBadgeLabel:nil];
    }
}

-(void)applicationDidBecomeActive:(NSNotification *) notification {
    if (self.selectedBuffer.numberOfUnreadHighlights) {
        self.selectedBuffer.numberOfUnreadHighlights = 0;
        [self.buffersOutlineView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:self.buffersOutlineView.selectedRow]
                                           columnIndexes:[NSIndexSet indexSetWithIndex:0]];
        [self updateDockTile];
    }
}

#pragma mark - IBActions

#pragma mark - MXIClientDelegate

- (void)client:(MXIClient *)client didReceiveBufferEvent:(MXIAbstractClientBufferEvent *)bufferEvent {
    if (self.selectedBuffer.bufferId == bufferEvent.bufferId) {
        [self.bufferTextView.textStorage appendAttributedString:[bufferEvent renderToAttributedString]];
        [self.bufferTextView scrollToEndOfDocument:self];

        if ([bufferEvent isKindOfClass:[MXIClientBufferJoin class]] || [bufferEvent isKindOfClass:[MXIClientBufferLeave class]] || [bufferEvent isKindOfClass:[MXIClientBufferQuit class]]) {
            [self.nicklistTableView reloadData];
        }

        if (self.backlogFinished && [bufferEvent isKindOfClass:[MXIClientBufferMessage class]] &&  [NSApplication sharedApplication].active) {
            [self.selectedBuffer markEventSeen:bufferEvent];
        }
    }
    
    if (bufferEvent.highlightsUser.boolValue) {
        //Display when buffer is not visible or app is not active
        if (self.selectedBuffer.bufferId == bufferEvent.bufferId || ![NSApplication sharedApplication].active) {
            MXIClientBuffer *buffer = self.client.buffers[bufferEvent.bufferId];
            if (bufferEvent.eventId > buffer.lastSeenEid) {
                buffer.numberOfUnreadHighlights++;
                NSInteger row = [self.buffersOutlineView rowForItem:buffer];
                [self.buffersOutlineView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:row]
                                                   columnIndexes:[NSIndexSet indexSetWithIndex:0]];
                [self updateDockTile];
            }
        }
    }
    
    if (self.backlogFinished && bufferEvent.highlightsUser.boolValue) {
        [self displayUserNotificationForEvent:bufferEvent];
    }

}

- (void)clientDidFinishInitialBacklog:(MXIClient *)client {
    [self.buffersOutlineView reloadData];
    [self.buffersOutlineView expandItem:nil expandChildren:YES];
    self.backlogFinished = YES;
    if (self.client.lastSelectedBid) {
        MXIClientBuffer *buffer = self.client.buffers[self.client.lastSelectedBid];
        NSInteger row = [self.buffersOutlineView rowForItem:buffer];
        [self.buffersOutlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
    }
}

#pragma mark - NSOutlineViewDelegate

// NSStatusAvailable and NSStatusUnavailable are not local assets
#pragma clang diagnostic push
#pragma ide diagnostic ignored "ResourceNotFoundInspection"

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    if ([self.client.serverOrder containsObject:item]) {
        MXIBufferTableCellView *serverCellView = [outlineView makeViewWithIdentifier:@"HeaderCell" owner:self];
        MXIClientServer *server = item;
        
        [serverCellView setStatusImageForStatus:server.status];
        serverCellView.titleField.stringValue = [server.name uppercaseString];
        [serverCellView setBadgeNumberTo:server.serverConsoleBuffer.numberOfUnreadHighlights];
        return serverCellView;
    } else {
        MXIClientBuffer *buffer = item;
        MXIBufferTableCellView *bufferCellView = [outlineView makeViewWithIdentifier:@"DataCell" owner:self];
        bufferCellView.titleField.stringValue = buffer.name;
        [bufferCellView setBadgeNumberTo:buffer.numberOfUnreadHighlights];
        return bufferCellView;
    }
}

#pragma clang diagnostic pop

- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    if (self.selectedBuffer) {
        NSMutableAttributedString *bufferText = [[NSMutableAttributedString alloc] init];
        for (MXIClientBufferMessage *bufferMessage in self.selectedBuffer.events) {
            [bufferText appendAttributedString:[bufferMessage renderToAttributedString]];
        }
        self.bufferTextView.textStorage.attributedString = bufferText;
        [self.bufferTextView scrollToEndOfDocument:self];
        [self focusMessageTextField];
        [self.nicklistTableView reloadData];
        [self.selectedBuffer makeSelected];
        [self.buffersOutlineView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:self.buffersOutlineView.selectedRow]
                                           columnIndexes:[NSIndexSet indexSetWithIndex:0]];
        [self updateDockTile];
    }
}

#pragma mark - NSOutlineViewDataSource

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

#pragma mark - NSTableViewDelegate

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTableCellView *cell = [tableView makeViewWithIdentifier:@"NickCell" owner:self];

    MXIClientUser *user = self.selectedBuffer.channel.members[(NSUInteger) row];
    cell.textField.stringValue = user.nick;
    //Set image to nil, until we have proper images for OP, voice, etc.
    cell.imageView.image = nil;
    return cell;
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.selectedBuffer.channel.members count];
}

#pragma mark - MXIMessageTextViewDelegate

- (void)messageTextViewPressedReturn:(MXIMessageTextView *)messageTextView {
    [self.selectedBuffer sendMessageWithString:messageTextView.string];
    messageTextView.string = @"";
}

- (NSArray *)messageTextView:(MXIMessageTextView *)messageTextView completionsForWord:(NSString *)word isFirstWord:(BOOL)isFirstWord {
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    for (MXIClientUser *user in self.selectedBuffer.channel.members) {
        if ([user.nick.lowercaseString hasPrefix:word.lowercaseString]) {
            if (isFirstWord) {
                [ret addObject:[user.nick stringByAppendingString:@": "]];
            } else {
                [ret addObject:[user.nick stringByAppendingString:@" "]];
            }
        }
    }
    return ret;
}

@end
