//
//  MXIClient.h
//  Rainchat
//
//  Created by Maximilian Gaß on 05.09.13.
//

#import <Foundation/Foundation.h>

#import "MXIClientDelegate.h"
#import "MXIClientTransport.h"
#import "MXIClientTransportDelegate.h"

@interface MXIClient : NSObject <MXIClientTransportDelegate>
- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password;

@property(nonatomic) NSMutableDictionary *servers;

@property(nonatomic) NSMutableArray *serverOrder;
@property(nonatomic) id <MXIClientDelegate> delegate;
@property(nonatomic, strong) NSMutableDictionary *buffers;
@property(nonatomic) MXIClientTransport *transport;
@property(nonatomic, strong) NSArray *highlightStrings;

@end
