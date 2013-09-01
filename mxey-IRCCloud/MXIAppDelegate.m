//
//  MXIAppDelegate.m
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 01.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import "MXIAppDelegate.h"
#import "AFHTTPClient.h"
#import "SRWebSocket.h"
#import "RFKeychain.h"


@implementation MXIAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSString *account = @"mxey@mxey.net";
    NSString *password = [RFKeychain passwordForAccount:account service:@"IRCCloud"];
    self.connection = [[MXIConnection alloc] initWithEmail:account andPassword:password];
    self.connection.delegate = self;
}

- (void)connection:(MXIConnection *)connection didReceiveBufferMsg:(NSDictionary *)bufferMsg
{
    NSString *output = [NSString stringWithFormat:@"%@ <%@> %@\n", bufferMsg[@"chan"], bufferMsg[@"from"], bufferMsg[@"msg"]];
    NSMutableString *text = [self.textView.string mutableCopy];
    [text appendString:output];
    self.textView.string = text;
}




@end
