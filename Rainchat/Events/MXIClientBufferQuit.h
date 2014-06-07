//
//  MXIClientBufferQuit.h
//  Rainchat
//
//  Created by Maximilian Gaß on 07.06.14.
//  Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//

#import "MXIAbstractClientBufferEvent.h"

@interface MXIClientBufferQuit : MXIAbstractClientBufferEvent
@property(nonatomic) NSString *fromNick;
@property(nonatomic) NSString *message;
@end
