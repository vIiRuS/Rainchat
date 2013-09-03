#import <Kiwi.h>
#import "MXIClient.h"

@interface MXIClient (Test)
- (NSURLRequest *)makeLoginRequestWithEmail:(NSString *)email andPassword:(NSString *)password;
- (void)processMessage:(NSDictionary *)messageAttributes;
@end

SPEC_BEGIN(MXIClientSpec)

describe(@"MXIClient", ^{
    NSString *email = @"foo@example.com";
    NSString *password = @"password";
    __block MXIClient *client;
    
    beforeEach(^{
        client = [[MXIClient alloc] init];
    });
    
    it(@"makes a login request with given email and password", ^{
        NSURLRequest *loginRequest = [client makeLoginRequestWithEmail:email andPassword:password];
        [[loginRequest.URL should] equal:[NSURL URLWithString:@"https://www.irccloud.com/chat/login"]];
        NSString *loginRequestBodyString = [[NSString alloc] initWithData:loginRequest.HTTPBody encoding:NSUTF8StringEncoding];
        [[loginRequestBodyString should] equal:@"email=foo%40example.com&password=password"];
        [[loginRequest.HTTPMethod should] equal:@"POST"];
        [[theValue(loginRequest.HTTPShouldHandleCookies) should] equal:theValue(NO)];
    });
    
    it(@"notifies delegate of incoming message", ^{
        NSDictionary *bufferMsgAttributes = @{
            @"type": @"buffer_msg",
            @"cid": @1,
            @"bid": @1,
            @"eid": @1,
            @"chan": @"#channel",
            @"from": @"from",
            @"msg": @"message",
        };
        id delegate = [KWMock mockForProtocol:@protocol(MXIClientDelegate)];
        [[delegate should] receive:@selector(client:didReceiveBufferMsg:)];
        client.delegate = delegate;
        [client processMessage:bufferMsgAttributes];
    });
});

SPEC_END