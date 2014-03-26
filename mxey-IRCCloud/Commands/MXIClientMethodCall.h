//
// Created by Maximilian Gaß on 26.03.14.
// Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"


@interface MXIClientMethodCall : JSONModel
@property(nonatomic) NSString *methodName;
@property(nonatomic) NSNumber *requestId;
@end
