//
//  MXIMessageTextField.h
//  Rainchat
//
//  Created by Thomas Roth on 07/06/14.
//

#import <Cocoa/Cocoa.h>

@protocol MXIMessageTextViewDelegate <NSTextFieldDelegate>

- (void)returnPressed:(NSTextView*)textView;
- (NSArray*)completionsForWord:(NSString*)word isFirstWord:(BOOL)isFirstWord;

@end

@interface MXIMessageTextView : NSTextView <NSTextViewDelegate>

@property(nonatomic) id <MXIMessageTextViewDelegate> delegate;

@end
