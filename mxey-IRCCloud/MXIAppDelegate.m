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


@implementation MXIAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSString *account = @"mxey@mxey.net";
    NSString *password = [RFKeychain passwordForAccount:account service:@"IRCCloud"];
    self.connection = [[MXIClient alloc] initWithEmail:account andPassword:password];
    self.connection.delegate = self;
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
}




@end
