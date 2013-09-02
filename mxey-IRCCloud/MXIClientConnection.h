//
//  MXIClientConnection.h
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 02.09.13.
//  Copyright (c) 2013 Maximilian Gaß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

@interface MXIClientConnection : JSONModel
@property (nonatomic) NSNumber *connectionId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *nick;
@end
