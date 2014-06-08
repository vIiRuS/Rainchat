//
//  MXIAppDelegate.h
//  Rainchat
//
//  Created by Maximilian Gaß on 01.09.13.
//

#import <Cocoa/Cocoa.h>
#import "MXIChatWindowController.h"

@interface MXIAppDelegate : NSObject <NSApplicationDelegate>

@property (retain) MXIChatWindowController *chatWindowController;

@end
