//
//  MXIConnection.m
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 01.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import "MXIClientTransport.h"
#import "MXIClient.h"
#import "Events/MXIClientBuffer.h"
#import "Events/MXIClientServer.h"
#import "MXIClientSayMethodCall.h"
#import "MXIClientUserStats.h"
#import "MXIClientBufferAction.h"
#import "MXIClientBufferNotice.h"
#import "MXIClientChannel.h"

@interface MXIClientTransport ()
@property(nonatomic) SRWebSocket *webSocket;
@property(nonatomic) NSURL *IRCCloudURL;
@property(nonatomic) NSString *cookie;
@property(nonatomic) NSUInteger nextMethodCallRequestId;
@property(nonatomic, strong) NSMutableDictionary *unansweredMethodCalls;
@end


@interface MXIClientTransport ()
@property(nonatomic) NSMutableArray *messageBufferDuringBacklog;
@property(nonatomic) BOOL processingBacklog;
@end

@implementation MXIClientTransport
- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.IRCCloudURL = [NSURL URLWithString:@"https://www.irccloud.com/chat/"];
    self.nextMethodCallRequestId = 0;
    self.unansweredMethodCalls = [NSMutableDictionary dictionary];
    return self;
}

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password {
    NSMutableURLRequest *formTokenRequest = [NSMutableURLRequest requestWithURL:[self.IRCCloudURL URLByAppendingPathComponent:@"auth-formtoken"]];
    formTokenRequest.HTTPMethod = @"POST";

    [NSURLConnection sendAsynchronousRequest:formTokenRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *decodedResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];

        if ([decodedResponse[@"success"] isEqual:@YES]) {
            [self performLoginWithEmail:email password:password token:decodedResponse[@"token"]];
        } else {
            NSLog(@"failed to get auth token: %@", decodedResponse[@"message"]);
        }
    }];
}

- (void)performLoginWithEmail:(NSString *)email password:(NSString *)password token:(id)token {
    NSMutableURLRequest *loginRequest = [NSMutableURLRequest requestWithURL:[self.IRCCloudURL URLByAppendingPathComponent:@"login"]];
    NSData *loginPostBody = [[NSString stringWithFormat:@"email=%@&password=%@&token=%@", [self URLEncodeString:email], [self URLEncodeString:password], [self URLEncodeString:token]] dataUsingEncoding:NSUTF8StringEncoding];
    loginRequest.HTTPBody = loginPostBody;
    [loginRequest addValue:token forHTTPHeaderField:@"x-auth-formtoken"];
    loginRequest.HTTPMethod = @"POST";
    loginRequest.HTTPShouldHandleCookies = false;

    [NSURLConnection sendAsynchronousRequest:loginRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *decodedResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        if ([decodedResponse[@"success"] isEqual:@YES]) {
            // Set cookie manually from session ID, instead of copying it from HTTP response, because IRCCloud's WebSocket will not accept their own cookie flags
            self.cookie = [NSString stringWithFormat:@"%@=%@", @"session", decodedResponse[@"session"]];
            [self openWebSocket];
        } else {
            NSLog(@"failed to log in: %@", decodedResponse[@"message"]);
        }
    }];
}


// From http://stackoverflow.com/questions/3423545/objective-c-iphone-percent-encode-a-string/3426140#3426140
- URLEncodeString:(NSString *)string {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *) [string UTF8String];
    unsigned long sourceLen = strlen((const char *) source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' ') {
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

- (NSURLRequest *)makeWebSocketURLRequest {
    NSMutableURLRequest *webSocketURLRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"wss://www.irccloud.com/"]];

    webSocketURLRequest.HTTPShouldHandleCookies = false;
    [webSocketURLRequest setValue:self.cookie forHTTPHeaderField:@"Cookie"];
    [webSocketURLRequest setValue:@"https://www.irccloud.com" forHTTPHeaderField:@"Origin"];
    [webSocketURLRequest setValue:@"mxey-IRCCloud" forHTTPHeaderField:@"User-Agent"];
    return webSocketURLRequest;
}

- (void)openWebSocket {
    NSURLRequest *webSocketURLRequest = [self makeWebSocketURLRequest];
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:webSocketURLRequest];
    self.webSocket.delegate = self;
    [self.webSocket open];
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket; {
    NSLog(@"Websocket Connected");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error; {
    NSLog(@":( Websocket Failed With Error %@", error);
    self.webSocket = nil;
}

- (void)processMessage:(NSDictionary *)messageAttributes fromBacklog:(BOOL)fromBacklog {
    if (self.processingBacklog && !fromBacklog) {
        [self.messageBufferDuringBacklog addObject:messageAttributes];
        return;
    }

    if (messageAttributes[@"_reqid"]) {
        NSNumber *requestId = messageAttributes[@"_reqid"];
        MXIClientMethodCall *methodCall = self.unansweredMethodCalls[requestId];
        if (methodCall) {
            [self methodCall:methodCall didFinish:[messageAttributes[@"success"] boolValue] error:messageAttributes[@"message"]];
        }
    }
    else if ([messageAttributes[@"type"] isEqualTo:@"oob_include"]) {
        [self loadInitialBacklogFromURLString:messageAttributes[@"url"]];
    }
    else if ([messageAttributes[@"type"] isEqualTo:@"backlog_complete"]) {
        [self finishInitialBacklog];
    }
    else {
        [self createMessageModelObjectWithAttributes:messageAttributes fromBacklog:fromBacklog];
    }
}

- (void)methodCall:(MXIClientMethodCall *)methodCall didFinish:(BOOL)successful error:(NSString *)errorMessage {
    if (!successful) {
        NSLog(@"Method call %@ failed: %@", methodCall, errorMessage);
    }
}

- (void)createMessageModelObjectWithAttributes:(NSDictionary *)messageAttributes fromBacklog:(BOOL)fromBacklog {
    NSDictionary *messageModelClasses = @{
        @"buffer_msg" : [MXIClientBufferMessage class],
        @"buffer_me_msg" : [MXIClientBufferAction class],
        @"notice" : [MXIClientBufferNotice class],
        @"makeserver" : [MXIClientServer class],
        @"makebuffer" : [MXIClientBuffer class],
        @"stat_user" : [MXIClientUserStats class],
        @"channel_init" : [MXIClientChannel class],
    };
    NSError *error;
    Class messageModelClass = messageModelClasses[messageAttributes[@"type"]];
    if (!messageModelClass) {
        NSLog(@"Unhandled IRCCloud stream message type: %@", messageAttributes[@"type"]);
        return;
    }

    id messageModelObject = [MTLJSONAdapter modelOfClass:messageModelClass fromJSONDictionary:messageAttributes error:&error];
    if (!messageModelObject) {
        NSLog(@"Failed to create model object %@: %@", messageModelClass, [error localizedDescription]);
        return;
    }

    if ([messageModelObject respondsToSelector:@selector(setTransport:)]) {
        [messageModelObject setTransport:self];
    }

    [self.delegate transport:self receivedMessage:messageModelObject fromBacklog:fromBacklog];
}

- (void)finishInitialBacklog {
    self.processingBacklog = NO;
    NSLog(@"Initial backlog finished");

    NSLog(@"Handling messages received during backlog replay");
    for (id backlogMessage in self.messageBufferDuringBacklog) {
        [self.delegate transport:self receivedMessage:backlogMessage fromBacklog:NO];
    }
    self.messageBufferDuringBacklog = nil;
    [self.delegate transportDidFinishInitialBacklog:self];
}

- (void)loadInitialBacklogFromURLString:(NSString *)backlogURLString {
    NSLog(@"Initial backlog start");
    self.messageBufferDuringBacklog = [NSMutableArray array];
    self.processingBacklog = YES;
    [self loadBacklogFromRelativeURL:backlogURLString];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(NSString *)message; {
    NSData *messageData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *messageAttributes = [NSJSONSerialization JSONObjectWithData:messageData options:0 error:NULL];

    [self processMessage:messageAttributes fromBacklog:NO];
}

- (void)loadBacklogFromRelativeURL:(NSString *)relativeURL {
    NSURL *URL = [NSURL URLWithString:relativeURL relativeToURL:self.IRCCloudURL];
    NSMutableURLRequest *backlogFetchRequest = [NSMutableURLRequest requestWithURL:URL];
    backlogFetchRequest.HTTPShouldHandleCookies = false;
    [backlogFetchRequest setValue:self.cookie forHTTPHeaderField:@"Cookie"];
    [NSURLConnection sendAsynchronousRequest:backlogFetchRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSArray *decodedBacklog = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        for (NSDictionary *messageAttributes in decodedBacklog) {
            [self processMessage:messageAttributes fromBacklog:YES];
        }
    }];
}

- (void)callMethod:(MXIClientMethodCall *)methodCall {
    methodCall.requestId = [self incrementAndReturnRequestId];
    self.unansweredMethodCalls[methodCall.requestId] = methodCall;

    NSError *error = nil;
    NSData *methodCallData = [NSJSONSerialization dataWithJSONObject:[MTLJSONAdapter JSONDictionaryFromModel:methodCall] options:0 error:&error];
    if (error) {
        NSLog(@"Error serializing method call: %@", [error localizedDescription]);
    }
    NSString *methodCallString = [[NSString alloc] initWithData:methodCallData encoding:NSUTF8StringEncoding];

    [self.webSocket send:methodCallString];
}

- (NSNumber *)incrementAndReturnRequestId {
    NSUInteger methodCallRequestId = self.nextMethodCallRequestId;
    self.nextMethodCallRequestId++;
    return @(methodCallRequestId);
}
@end

