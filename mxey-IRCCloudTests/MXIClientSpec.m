#import <Kiwi.h>
#import "MXIClient.h"

@interface MXIClient (Test)
- (NSURLRequest *)makeLoginRequestWithEmail:(NSString *)email andPassword:(NSString *)password;
@end

SPEC_BEGIN(MXIClientSpec)

describe(@"MXIClient", ^{
    NSString *email = @"foo@example.com";
    NSString *password = @"password";
    
    it(@"makes a login request with given email and password", ^{
        MXIClient *client = [[MXIClient alloc] init];
        NSURLRequest *loginRequest = [client makeLoginRequestWithEmail:email andPassword:password];
        [[loginRequest.URL should] equal:[NSURL URLWithString:@"https://www.irccloud.com/chat/login"]];
        NSString *loginRequestBodyString = [[NSString alloc] initWithData:loginRequest.HTTPBody encoding:NSUTF8StringEncoding];
        [[loginRequestBodyString should] equal:@"email=foo%40example.com&password=password"];
        [[loginRequest.HTTPMethod should] equal:@"POST"];
        [[theValue(loginRequest.HTTPShouldHandleCookies) should] equal:theValue(NO)];
    });
});

SPEC_END