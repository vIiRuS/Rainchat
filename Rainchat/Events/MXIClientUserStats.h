//
// Created by Maximilian Gaß on 06.04.14.
//

#import <Foundation/Foundation.h>
#import <Mantle/MTLModel.h>
#import <Mantle/MTLJSONAdapter.h>
#import "MXIClientEvent.h"


@interface MXIClientUserStats : MTLModel <MTLJSONSerializing, MXIClientEvent>
@property(nonatomic) NSArray *highlightStrings;
@property(nonatomic) NSNumber *lastSelectedBid;

@end
