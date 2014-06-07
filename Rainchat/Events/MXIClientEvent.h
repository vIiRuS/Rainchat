//
//  MXIClientProtocol.h
//  Rainchat
//
//  Created by Maximilian Gaß on 07.06.14.
//  Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MXIClient;

@protocol MXIClientEvent <NSObject>
- (void)processWithClient:(MXIClient *)client;
@end
