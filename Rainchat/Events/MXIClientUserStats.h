//
// Created by Maximilian Gaß on 06.04.14.
// Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/MTLModel.h>
#import <Mantle/MTLJSONAdapter.h>


@interface MXIClientUserStats : MTLModel <MTLJSONSerializing>
@property(nonatomic) NSArray *highlightStrings;
@end
