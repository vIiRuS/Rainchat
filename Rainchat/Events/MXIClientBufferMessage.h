//
//  MXIBufferMessage.h
//  Rainchat
//
//  Created by Maximilian Gaß on 02.09.13.
//

#import <Foundation/Foundation.h>
#import <Mantle/MTLModel.h>
#import <Mantle/MTLJSONAdapter.h>
#import "MXIAbstractClientBufferEvent.h"

@interface MXIClientBufferMessage : MXIAbstractClientBufferEvent
@property(nonatomic) NSString *body;

- (NSString *)string;
@end
