//
//  MXIAppDelegate.h
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 01.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MXIChatWindowController.h"

@interface MXIAppDelegate : NSObject <NSApplicationDelegate>

@property (retain) MXIChatWindowController *chatWindowController;

@end
