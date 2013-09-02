//
//  MXIConnection.m
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 01.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import "MXIClient.h"
#import "MXIClientBufferMessage.h"
#import "MXIClientConnection.h"
#import <SRWebSocket.h>

@interface MXIClient ()
@property (nonatomic) SRWebSocket *webSocket;
@property (nonatomic) NSURL *IRCCloudURL;
@property (nonatomic) NSString *cookie;
@property (nonatomic) NSMutableDictionary *connections;
@end


@implementation MXIClient
- (id)initWithEmail:(NSString *)email andPassword:(NSString *)password
{
    self = [self init];
    if (!self) {
        return nil;
    }

    self.IRCCloudURL = [NSURL URLWithString:@"https://www.irccloud.com/chat/"];
    self.connections = [NSMutableDictionary dictionary];
    [self loginWithEmail:email andPassword:password];
    
    return self;
}

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password
{
    NSMutableURLRequest *loginRequest = [NSMutableURLRequest requestWithURL:[self.IRCCloudURL URLByAppendingPathComponent:@"login"]];
    NSData *loginPostBody = [[NSString stringWithFormat:@"email=%@&password=%@", [self URLEncodeString:email], [self URLEncodeString:password]] dataUsingEncoding:NSUTF8StringEncoding];
    loginRequest.HTTPBody = loginPostBody;
    loginRequest.HTTPMethod = @"POST";
    loginRequest.HTTPShouldHandleCookies = false;
    
    [NSURLConnection sendAsynchronousRequest:loginRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
        self.cookie = [HTTPResponse allHeaderFields][@"Set-Cookie"];
        [self openWebSocket];
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

- (void)openWebSocket
{
    NSMutableURLRequest *webSocketURLRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"wss://www.irccloud.com/"]];
    
    webSocketURLRequest.HTTPShouldHandleCookies = false;
    [webSocketURLRequest setValue:self.cookie forHTTPHeaderField:@"Cookie"];
    [webSocketURLRequest setValue:@"https://www.irccloud.com" forHTTPHeaderField:@"Origin"];
    
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

- (void)processMessage:(NSDictionary *)messageAttributes
{
    NSDictionary *messageHandlers = @{
        @"buffer_msg": ^() {
            NSError *error;
            MXIClientBufferMessage *bufferMessage = [[MXIClientBufferMessage alloc] initWithDictionary:messageAttributes error:NULL];
            if (!bufferMessage) {
                NSLog(@"%@", [error localizedDescription]);
                return;
            }

            [self.delegate connection:self didReceiveBufferMsg:bufferMessage];
        },
        @"oob_include": ^() {
            [self loadInitialBacklogFromURL:[NSURL URLWithString:messageAttributes[@"url"] relativeToURL:self.IRCCloudURL]];
        },
        @"makeserver": ^() {
            NSError *error;
            MXIClientConnection *connection = [[MXIClientConnection alloc] initWithDictionary:messageAttributes error:&error];
            if (!connection) {
                NSLog(@"%@", [error localizedDescription]);
                return;
            }
            
            self.connections[connection.name] = connection;
            NSLog(@"Connections: %@", self.connections);
        }
    };
    
    
    void (^messageHandler)()  = messageHandlers[messageAttributes[@"type"]];
    if (messageHandler) {
        messageHandler();
    }
    else {
        NSLog(@"Unhandled message type: %@", messageAttributes[@"type"]);
    }
   
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(NSString *)message;
{
    NSData *messageData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *messageAttributes = [NSJSONSerialization JSONObjectWithData:messageData options:0 error:NULL];
    [self processMessage:messageAttributes];
}

- (void)loadInitialBacklogFromURL:(NSURL *)URL
{
    NSMutableURLRequest *backlogFetchRequest = [NSMutableURLRequest requestWithURL:URL];
    backlogFetchRequest.HTTPShouldHandleCookies = false;
    [backlogFetchRequest setValue:self.cookie forHTTPHeaderField:@"Cookie"];
    [NSURLConnection sendAsynchronousRequest:backlogFetchRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSArray *decodedBacklog = [NSJSONSerialization JSONObjectWithData:data options:NULL error:NULL];
        for (NSDictionary *messageAttributes in decodedBacklog) {
            [self processMessage:messageAttributes];
        }
    }];
}

@end
