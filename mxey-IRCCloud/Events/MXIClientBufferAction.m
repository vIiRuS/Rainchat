//
// Created by Maximilian Gaß on 13.04.14.
// Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//

#import "MXIClientBufferAction.h"


@implementation MXIClientBufferAction {

}
- (NSString *)string {
    return [NSString stringWithFormat:@"* %@ %@", self.fromNick, self.body];
}

@end
