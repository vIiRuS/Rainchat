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
#import "MXILoginSheetController.h"
#import "MXIClientUser.h"

@interface MXIAppDelegate ()
@property(nonatomic) BOOL backlogFinished;
@property(nonatomic, strong) MXILoginSheetController *sheetController;
@end

@implementation MXIAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    if (self.userAccount && self.userPassword) {
        [self login];
    } else {
        [self presentLoginSheet];
    }
}

- (void)login {
    NSLog(@"Logging in");
    self.client = [[MXIClient alloc] init];
    self.client.delegate = self;
    self.messageTextField.delegate = self;
    [self.client loginWithEmail:self.userAccount andPassword:self.userPassword];
}

- (NSString *)userAccount {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"userAccount"];
}

- (void)setUserAccount:(NSString *)userAccount {
    [[NSUserDefaults standardUserDefaults] setObject:userAccount forKey:@"userAccount"];
}

- (NSString *)userPassword {
    return [RFKeychain passwordForAccount:[self userAccount] service:@"IRCCloud"];
}

- (void)setUserPassword:(NSString *)userPassword {
    [RFKeychain setPassword:userPassword account:self.userAccount service:@"IRCCloud"];
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


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.getSelectedBuffer.channel.members count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTableCellView *cell = [tableView makeViewWithIdentifier:@"NickCell" owner:self];
    
    MXIClientUser *user = self.getSelectedBuffer.channel.members[row];
    cell.textField.stringValue = user.nick;
    //Set image to nil, until we have proper images for OP, voice, etc.
    cell.imageView.image = nil;
    return cell;
}


- (void)client:(MXIClient *)client didReceiveBufferEvent:(MXIAbstractClientBufferEvent *)bufferEvent {
    if ([self getSelectedBuffer].bufferId == bufferEvent.bufferId) {
        [self.bufferTextView.textStorage appendAttributedString:[bufferEvent renderToAttributedString]];
        [self.bufferTextView scrollToEndOfDocument:self];
    }
    if (self.backlogFinished && bufferEvent.highlightsUser.boolValue) {
        [self displayUserNotificationForEvent:bufferEvent];
    }
}

- (void)displayUserNotificationForEvent:(MXIAbstractClientBufferEvent *)bufferEvent {
    MXIClientBuffer *buffer = self.client.buffers[bufferEvent.bufferId];
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = buffer.name;
    notification.informativeText = bufferEvent.string;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

- (void)clientDidFinishInitialBacklog:(MXIClient *)client {
    [self.buffersOutlineView reloadData];
    [self.buffersOutlineView expandItem:nil expandChildren:YES];
    self.backlogFinished = YES;
}


- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    MXIClientBuffer *selectedBuffer = [self getSelectedBuffer];
    if (selectedBuffer) {
        NSMutableAttributedString *bufferText = [[NSMutableAttributedString alloc] init];
        for (MXIClientBufferMessage *bufferMessage in selectedBuffer.events) {
            [bufferText appendAttributedString:[bufferMessage renderToAttributedString]];
        }
        self.bufferTextView.textStorage.attributedString = bufferText;
        [self.bufferTextView scrollToEndOfDocument:self];
        [self focusMessageTextField];
        [self.nicklistTableView reloadData];
    }
}

- (void)focusMessageTextField {
    [self.window makeFirstResponder:self.messageTextField];
    self.messageTextField.currentEditor.selectedRange = NSMakeRange(self.messageTextField.stringValue.length, 0);
}

- (MXIClientBuffer *)getSelectedBuffer {
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


- (IBAction)pressedEnterInMessageTextField:(NSTextFieldCell *)sender {
    [self.getSelectedBuffer sendMessageWithString:sender.stringValue];
    sender.stringValue = @"";
}



- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector {
    if (commandSelector == @selector(insertTab:)) {
        NSRange range = [textView selectedRange];
        if (range.location == textView.string.length) {
            __block NSString *completionWord = nil;
            __block NSRange completionRange;
            [textView.string enumerateSubstringsInRange:NSMakeRange(0, [textView.string length]) options:NSStringEnumerationByWords | NSStringEnumerationReverse usingBlock:^(NSString *substring, NSRange subrange, NSRange enclosingRange, BOOL *stop) {
                completionWord = substring;
                completionRange = enclosingRange;
                *stop = YES;
            }];
            NSString *foundNick;
            NSUInteger foundNickCount = 0;
            for (MXIClientUser *user in self.getSelectedBuffer.channel.members) {
                if (completionWord.length < user.nick.length) {
                    NSString *comparestring = [user.nick substringToIndex:completionWord.length];
                    if ([comparestring isEqualToString:completionWord]) {
                        foundNick = user.nick;
                        foundNickCount++;
                    }
                }
            }
            if (foundNickCount == 1) {
                NSMutableString *mutableString = [textView.string mutableCopy];
                [mutableString deleteCharactersInRange:completionRange];
                if (completionRange.location == 0) {
                    [mutableString insertString:[foundNick stringByAppendingString:@": "] atIndex:completionRange.location];
                } else {
                    [mutableString insertString:foundNick atIndex:completionRange.location];
                }
                textView.string = mutableString;
            }
        }
        return YES;
    }
    return NO;
}
@end
