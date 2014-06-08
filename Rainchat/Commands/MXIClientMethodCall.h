//
// Created by Maximilian Gaß on 26.03.14.
//

#import <Foundation/Foundation.h>
#import "MTLModel.h"
#import "MTLJSONAdapter.h"


@interface MXIClientMethodCall : MTLModel <MTLJSONSerializing>
@property(nonatomic, readonly) NSString *methodName;
@property(nonatomic) NSNumber *requestId;
@end
