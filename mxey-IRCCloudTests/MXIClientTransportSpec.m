#import <Kiwi.h>
#import "MXIClientTransport.h"

@interface MXIClientTransport (Test)
- (NSURLRequest *)makeLoginRequestWithEmail:(NSString *)email andPassword:(NSString *)password;
- (NSURLRequest *)makeWebSocketURLRequest;
- (void)processMessage:(NSDictionary *)messageAttributes;
- (void)setCookie:(NSString *)cookie;
@end

SPEC_BEGIN(MXIClientTransportSpec)

describe(@"MXIClientTransport", ^{
    NSString *email = @"foo@example.com";
    NSString *password = @"password";
    __block MXIClientTransport *transport;
    
    beforeEach(^{
        transport = [[MXIClientTransport alloc] initWithClient:nil];
    });
    
    describe(@"making a login NSURLRequest", ^{
        __block NSURLRequest *loginRequest;
        
        beforeEach(^{
            loginRequest = [transport makeLoginRequestWithEmail:email andPassword:password];
        });
        
        it(@"sets correct URL", ^{
            [[loginRequest.URL should] equal:[NSURL URLWithString:@"https://www.irccloud.com/chat/login"]];
        });
        
        it(@"sets correct request body", ^{
            NSString *loginRequestBodyString = [[NSString alloc] initWithData:loginRequest.HTTPBody encoding:NSUTF8StringEncoding];
            [[loginRequestBodyString should] equal:@"email=foo%40example.com&password=password"];
        });
        
        it(@"sets correct request method", ^{
            [[loginRequest.HTTPMethod should] equal:@"POST"];
        });
    });
    
    describe(@"making a base NSURLRequest for the WebSocket", ^{
        __block NSURLRequest *webSocketRequest;
        NSString *sessionCookie = @"faketestsessioncookie";
        
        beforeEach(^{
            transport.cookie = sessionCookie;
            webSocketRequest = [transport makeWebSocketURLRequest];
        });
        
        it(@"sets correct URL", ^{
            [[webSocketRequest.URL should] equal:[NSURL URLWithString:@"wss://www.irccloud.com/"]];
        });
        
        it(@"sets correct Origin header", ^{
            [[[webSocketRequest valueForHTTPHeaderField:@"Origin"] should] equal:@"https://www.irccloud.com"];
        });
        
        it(@"sets correct cookie", ^{
            [[[webSocketRequest valueForHTTPHeaderField:@"Cookie"] should] equal:sessionCookie];
        });
    });
    
//    it(@"notifies delegate of incoming message", ^{
//        NSDictionary *bufferMsgAttributes = @{
//            @"type": @"buffer_msg",
//            @"cid": @1,
//            @"bid": @1,
//            @"eid": @1,
//            @"chan": @"#channel",
//            @"from": @"from",
//            @"msg": @"message",
//        };
//        id delegate = [KWMock mockForProtocol:@protocol(MXIClientDelegate)];
//        [[delegate should] receive:@selector(client:didReceiveBufferMsg:)];
//        client.delegate = delegate;
//        [client processMessage:bufferMsgAttributes];
//    });
});

SPEC_END