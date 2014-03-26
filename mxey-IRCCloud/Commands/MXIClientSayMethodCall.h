//
// Created by Maximilian Gaß on 26.03.14.
// Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
#import "MXIClientMethodCall.h"


@interface MXIClientSayMethodCall : MXIClientMethodCall
@property(nonatomic) NSNumber *connectionId;
@property(nonatomic) NSString *bufferName;
@property(nonatomic) NSString *message;
@end
