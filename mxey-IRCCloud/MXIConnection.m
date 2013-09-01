//
//  MXIConnection.m
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 01.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import "MXIConnection.h"
#import <AFHTTPClient.h>
#import <SRWebSocket.h>

@interface MXIConnection ()
@property (nonatomic) SRWebSocket *webSocket;
@end


@implementation MXIConnection
- (id)initWithEmail:(NSString *)email andPassword:(NSString *)password
{
    self = [self init];
    if (!self) {
        return nil;
    }
    
    AFHTTPClient *HTTPClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.irccloud.com/chat/"]];
    NSDictionary *loginParameters = @{@"email": email, @"password": password};
    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"https://www.irccloud.com/chat/"]];
    
    if (cookies.count == 0) {
        [HTTPClient postPath:@"login" parameters:loginParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success: %@", responseObject);
            [self openWebSocket];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failure: %@", error);
        }];
    } else {
        [self openWebSocket];
    }
    
    return self;
}

- (void)openWebSocket
{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"https://www.irccloud.com/chat/"]];
    NSMutableURLRequest *webSocketURLRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"wss://www.irccloud.com/"]];
    
    [webSocketURLRequest setAllHTTPHeaderFields:[NSHTTPCookie requestHeaderFieldsWithCookies:cookies]];
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

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(NSString *)message;
{
    NSData *messageData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *messageObject = [NSJSONSerialization JSONObjectWithData:messageData options:0 error:NULL];
    NSLog(@"Received \"%@\"", messageObject);
    
    if ([messageObject[@"type"] isEqualToString:@"buffer_msg"]) {
        [self.delegate connection:self didReceiveBufferMsg:messageObject];
    }
    
}

@end
