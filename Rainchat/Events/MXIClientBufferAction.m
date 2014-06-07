//
// Created by Maximilian Gaß on 13.04.14.
//

#import "MXIClientBufferAction.h"


@implementation MXIClientBufferAction {

}
- (NSString *)string {
    return [NSString stringWithFormat:@"* %@ %@", self.fromNick, self.body];
}

@end
