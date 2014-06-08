//
//  MXIClientBufferLeave.h
//  Rainchat
//
//  Created by Phillip on 05/06/14.
//

#import "MXIAbstractClientBufferEvent.h"

@interface MXIClientBufferLeave : MXIAbstractClientBufferEvent

@property(nonatomic) NSString *fromNick;
@property(nonatomic) NSString *message;
@property(nonatomic) NSString *channelName;

- (NSString *)string;

@end
