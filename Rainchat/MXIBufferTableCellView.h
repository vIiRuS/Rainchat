//
//  MXIBufferTableCellView.h
//  Rainchat
//
//  Created by viirus on 04/10/14.
//
//

#import <Cocoa/Cocoa.h>
#import "MXIClient.h"

@interface MXIBufferTableCellView : NSTableCellView

@property (nonatomic) NSTextField *badge;
@property (nonatomic) NSTextField *titleField;

- (void)setBadgeNumberTo:(NSInteger)number;

- (void)setStatusImageForStatus:(MXIClientServerStatus)status;

@end
