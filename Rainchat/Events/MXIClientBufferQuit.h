//
//  MXIClientBufferQuit.h
//  Rainchat
//
//  Created by Maximilian Gaß on 07.06.14.
//

#import "MXIAbstractClientBufferEvent.h"

@interface MXIClientBufferQuit : MXIAbstractClientBufferEvent
@property(nonatomic) NSString *message;
@end
