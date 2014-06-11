//
//  MXIMessageTextField.h
//  Rainchat
//
//  Created by Thomas Roth on 07/06/14.
//

#import <Cocoa/Cocoa.h>

@protocol MXIMessageTextViewDelegate;

@interface MXIMessageTextView : NSTextView

@property(nonatomic, weak) id <MXIMessageTextViewDelegate> delegate;

@end

@protocol MXIMessageTextViewDelegate

- (void)messageTextViewPressedReturn:(MXIMessageTextView *)messageTextView;

- (NSArray *)messageTextView:(MXIMessageTextView *)messageTextView completionsForWord:(NSString *)word isFirstWord:(BOOL)isFirstWord;

@end

