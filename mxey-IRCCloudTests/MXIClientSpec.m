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
    
    describe(@"making a login request", ^{
        __block NSURLRequest *loginRequest;
        
        beforeEach(^{
            loginRequest = [client makeLoginRequestWithEmail:email andPassword:password];
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
        
        it(@"disabled implicit cookie handling", ^{
            [[theValue(loginRequest.HTTPShouldHandleCookies) should] equal:theValue(NO)];
        });
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