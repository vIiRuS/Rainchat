//
//  MXIAppDelegate.h
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 01.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MXIConnection.h"
#import "MXIConnectionDelegate.h"

@interface MXIAppDelegate : NSObject <NSApplicationDelegate, MXIConnectionDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property (nonatomic) MXIConnection *connection;

@end
