//
// Created by Maximilian Gaß on 11.04.14.
// Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/MTLModel.h>
#import <Mantle/MTLJSONAdapter.h>
#import "MXIClientEvent.h"
#import "MXIClientBuffer.h"

@interface MXIAbstractClientBufferEvent : MTLModel <MTLJSONSerializing, MXIClientEvent>
@property(nonatomic) NSNumber *connectionId;
@property(nonatomic) NSNumber *bufferId;
@property(nonatomic) NSNumber *eventId;
@property(nonatomic) NSDate *timestamp;
@property(nonatomic) NSNumber *highlightsUser;

- (NSMutableDictionary *)stringAttributes;

- (NSAttributedString *)renderToAttributedString;

- (void)checkForHighlights:(NSArray *)highlightStrings;

- (NSString *)string;
@end
