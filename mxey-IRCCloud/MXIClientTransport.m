//
//  MXIConnection.m
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 01.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import "MXIClientTransport.h"
#import "MXIClient.h"
#import "MXIClientBuffer.h"
#import "MXIClientBufferMessage.h"
#import "MXIClientConnection.h"
#import "MXIClientInitialBacklog.h"
#import "MXIClientInitialBacklogEnd.h"
#import <SRWebSocket.h>


@interface MXIClientTransport ()
@property (nonatomic) SRWebSocket *webSocket;
@property (nonatomic) NSURL *IRCCloudURL;
@property (nonatomic) NSString *cookie;
@property (nonatomic) MXIClient *client;
@end


@implementation MXIClientTransport
- (id)initWithClient:(MXIClient *)client
{
    self = [super init];
    if (!self) {
        return nil;
    }

    self.IRCCloudURL = [NSURL URLWithString:@"https://www.irccloud.com/chat/"];
    self.client = client;
    return self;
}

- (NSURLRequest *)makeLoginRequestWithEmail:(NSString *)email andPassword:(NSString *)password
{
    NSMutableURLRequest *loginRequest = [NSMutableURLRequest requestWithURL:[self.IRCCloudURL URLByAppendingPathComponent:@"login"]];
    NSData *loginPostBody = [[NSString stringWithFormat:@"email=%@&password=%@", [self URLEncodeString:email], [self URLEncodeString:password]] dataUsingEncoding:NSUTF8StringEncoding];
    loginRequest.HTTPBody = loginPostBody;
    loginRequest.HTTPMethod = @"POST";
    loginRequest.HTTPShouldHandleCookies = false;
    return loginRequest;
}

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password
{
    NSURLRequest *loginRequest = [self makeLoginRequestWithEmail:email andPassword:password];
    [NSURLConnection sendAsynchronousRequest:loginRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
        NSDictionary *decodedResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        if (decodedResponse[@"success"]) {
            // Set cookie manually from session ID, instead of copying it from HTTP response, because IRCCloud's WebSocket will not accept their own cookie flags
            self.cookie = [NSString stringWithFormat:@"%@=%@", @"session", decodedResponse[@"session"]];
            [self openWebSocket];
        } else {
            NSLog(@"Failed to log in.");
        }
    }];
}

// From http://stackoverflow.com/questions/3423545/objective-c-iphone-percent-encode-a-string/3426140#3426140
- URLEncodeString:(NSString *)string
{
    NSMutableString * output = [NSMutableString string];
    const unsigned char * source = (const unsigned char *)[string UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

- (NSURLRequest *)makeWebSocketURLRequest
{
    NSMutableURLRequest *webSocketURLRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"wss://www.irccloud.com/"]];
    
    webSocketURLRequest.HTTPShouldHandleCookies = false;
    [webSocketURLRequest setValue:self.cookie forHTTPHeaderField:@"Cookie"];
    [webSocketURLRequest setValue:@"https://www.irccloud.com" forHTTPHeaderField:@"Origin"];
    [webSocketURLRequest setValue:@"mxey-IRCCloud" forHTTPHeaderField:@"User-Agent"];
    return webSocketURLRequest;
}

- (void)openWebSocket
{
    NSURLRequest *webSocketURLRequest = [self makeWebSocketURLRequest];
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:webSocketURLRequest];
    self.webSocket.delegate = self;
    [self.webSocket open];
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Websocket Connected");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@":( Websocket Failed With Error %@", error);
    self.webSocket = nil;
}

- (void)processMessage:(NSDictionary *)messageAttributes fromBacklog:(BOOL)fromBacklog
{
    NSDictionary *messageModelClasses = @{
                                     @"buffer_msg": [MXIClientBufferMessage class],
                                     @"makeserver": [MXIClientConnection class],
                                     @"makebuffer": [MXIClientBuffer class],
                                     @"oob_include": [MXIClientInitialBacklog class],
                                     @"backlog_complete": [MXIClientInitialBacklogEnd class],
                                     };
    
    NSError *error;
    Class messageModelClass = messageModelClasses[messageAttributes[@"type"]];
    if (!messageModelClass) {
        NSLog(@"Unhandled IRCCloud stream message type: %@", messageAttributes[@"type"]);
        return;
    }
    
    id messageModelObject = [[messageModelClass alloc] initWithDictionary:messageAttributes error:&error];
    if (!messageModelObject) {
        NSLog(@"Failed to create model object %@: %@", messageModelClass, [error localizedDescription]);
        return;
    }
    
    [self.client transport:self receivedMessage:messageModelObject fromBacklog:fromBacklog];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(NSString *)message;
{
    NSData *messageData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *messageAttributes = [NSJSONSerialization JSONObjectWithData:messageData options:0 error:NULL];
    
    [self processMessage:messageAttributes fromBacklog:NO];
}

- (void)loadBacklogFromRelativeURL:(NSString *)relativeURL
{
    NSURL *URL = [NSURL URLWithString:relativeURL relativeToURL:self.IRCCloudURL];
    NSMutableURLRequest *backlogFetchRequest = [NSMutableURLRequest requestWithURL:URL];
    backlogFetchRequest.HTTPShouldHandleCookies = false;
    [backlogFetchRequest setValue:self.cookie forHTTPHeaderField:@"Cookie"];
    [NSURLConnection sendAsynchronousRequest:backlogFetchRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSArray *decodedBacklog = [NSJSONSerialization JSONObjectWithData:data options:NULL error:NULL];
        for (NSDictionary *messageAttributes in decodedBacklog) {
            [self processMessage:messageAttributes fromBacklog:YES];
        }
    }];
}

@end
