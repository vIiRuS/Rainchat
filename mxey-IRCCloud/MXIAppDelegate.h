//
//  MXIAppDelegate.h
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 01.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MXIClient.h"
#import "MXIClientDelegate.h"

@interface MXIAppDelegate : NSObject <NSApplicationDelegate, MXIClientDelegate, NSOutlineViewDataSource, NSOutlineViewDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property (nonatomic) MXIClient *client;
@property (weak) IBOutlet NSOutlineView *sourceListView;
@property(weak) IBOutlet NSTextField *inputTextField;

- (IBAction)pressedEnterInInputTextField:(NSTextFieldCell *)sender;

@end
