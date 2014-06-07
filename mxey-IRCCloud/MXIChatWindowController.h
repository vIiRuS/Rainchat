//
//  MXIChatWindowController.h
//  mxey-IRCCloud
//
//  Created by Thomas Roth on 07/06/14.
//  Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MXIClient.h"
#import "MXIClientDelegate.h"

@interface MXIChatWindowController : NSWindowController <MXIClientDelegate, NSOutlineViewDelegate, NSOutlineViewDataSource, NSTableViewDelegate, NSTableViewDataSource, NSControlTextEditingDelegate>

@property (nonatomic) MXIClient *client;

#pragma mark - IBOutlets

@property(unsafe_unretained) IBOutlet NSTextView *bufferTextView;
@property(weak) IBOutlet NSOutlineView *buffersOutlineView;
@property(weak) IBOutlet NSTextField *messageTextField;
@property (weak) IBOutlet NSTableView *nicklistTableView;

#pragma mark - IBActions

- (IBAction)pressedEnterInMessageTextField:(NSTextFieldCell *)sender;

@end
