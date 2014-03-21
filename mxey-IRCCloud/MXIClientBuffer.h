//
//  MXIClientBuffer.h
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 02.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

@interface MXIClientBuffer : JSONModel
@property (nonatomic) NSNumber *connectionId;
@property (nonatomic) NSString *name;
@property(nonatomic) BOOL isArchived;
@end
