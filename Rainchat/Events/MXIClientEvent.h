//
//  MXIClientProtocol.h
//  Rainchat
//
//  Created by Maximilian Gaß on 07.06.14.
//

#import <Foundation/Foundation.h>

@class MXIClient;

@protocol MXIClientEvent <NSObject>
- (void)processWithClient:(MXIClient *)client;
@end
