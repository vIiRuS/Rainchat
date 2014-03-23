//
//  MXIClient.h
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 05.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MXIClientDelegate.h"
#import "MXIClientTransport.h"
#import "MXIClientTransportDelegate.h"

@interface MXIClient : NSObject <MXIClientTransportDelegate>
- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password;

@property (nonatomic) NSMutableDictionary *connections;
@property(nonatomic) NSMutableArray *connectionOrder;
@property (nonatomic) id<MXIClientDelegate> delegate;
@end
