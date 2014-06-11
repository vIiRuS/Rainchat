//
//  MXIMessageTextField.m
//  Rainchat
//
//  Created by Thomas Roth on 07/06/14.
//

#import "MXIMessageTextView.h"

@implementation MXIMessageTextView

#pragma mark - NSTextView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setFont:[NSFont fontWithName:@"HelveticaNeue" size:14]];
    }
    return self;
}

- (void)insertNewline:(id)sender {
    [self.delegate messageTextViewPressedReturn:self];
}

- (void)insertTab:(id)sender {
    [self complete:self];
}

- (NSArray *)completionsForPartialWordRange:(NSRange)charRange indexOfSelectedItem:(NSInteger *)index {
    NSString *currentWord = [self.string substringWithRange:charRange];
    BOOL isFirstWord = charRange.location == 0;
    NSArray *completions = [self.delegate messageTextView:self completionsForWord:currentWord isFirstWord:isFirstWord];
    if (completions.count == 1) {
        NSMutableString *text = [self.string mutableCopy];
        [text deleteCharactersInRange:charRange];
        [text appendString:completions[0]];
        [self setString:text];
        return @[];
    }
    return completions;
}

@end
