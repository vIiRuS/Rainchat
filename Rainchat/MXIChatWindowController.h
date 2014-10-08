//
//  MXIChatWindowController.h
//  Rainchat
//
//  Created by Thomas Roth on 07/06/14.
//

#import <Cocoa/Cocoa.h>

#import "MXIClient.h"
#import "MXIClientDelegate.h"
#import "MXIMessageTextView.h"
#import "MXIBufferWebView.h"

@interface MXIChatWindowController : NSWindowController <MXIClientDelegate, NSOutlineViewDelegate, NSOutlineViewDataSource, NSTableViewDelegate, NSTableViewDataSource, MXIMessageTextViewDelegate>

@property (nonatomic) MXIClient *client;

#pragma mark - IBOutlets

@property(weak) IBOutlet NSOutlineView *buffersOutlineView;
@property(assign) IBOutlet MXIMessageTextView *messageTextView;
@property (weak) IBOutlet NSTableView *nicklistTableView;
@property (weak) IBOutlet MXIBufferWebView *bufferWebView;

@end
