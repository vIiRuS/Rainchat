//
// Created by Maximilian Gaß on 26.03.14.
//

#import <Foundation/Foundation.h>
#import "MXIClientMethodCall.h"


@interface MXIClientSayMethodCall : MXIClientMethodCall
@property(nonatomic) NSNumber *connectionId;
@property(nonatomic) NSString *bufferName;
@property(nonatomic) NSString *body;
@end
