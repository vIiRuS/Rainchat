//
//  MXIAppDelegate.m
//  Rainchat
//
//  Created by Maximilian Gaß on 01.09.13.
//

#import "MXIAppDelegate.h"
#import "MXIChatWindowController.h"

@interface MXIAppDelegate ()
@end

@implementation MXIAppDelegate

#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.chatWindowController = [[MXIChatWindowController alloc] initWithWindowNibName:@"MXIChatWindowController"];
    [self.chatWindowController showWindow:self];
}

// NSApplicationDelegate Placeholders

/*
 - (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    
}

- (void)applicationWillBecomeActive:(NSNotification *)aNotification {
    
}
*/

@end
