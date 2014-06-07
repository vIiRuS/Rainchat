//
//  MXIMessageTextField.m
//  Rainchat
//
//  Created by Thomas Roth on 07/06/14.
//  Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//

#import "MXIMessageTextField.h"

@implementation MXIMessageTextField

@synthesize delegate;

#pragma mark - NSTextField

- (BOOL)textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector {
    if (commandSelector == @selector(insertTab:)) {
        textView.delegate = self;
        [self.currentEditor complete:self];
        return YES;
    }
    return NO;
}

#pragma mark - NSTextViewDelegate

- (NSArray *)textView:(NSTextView *)textView completions:(NSArray *)words forPartialWordRange:(NSRange)charRange indexOfSelectedItem:(NSInteger *)index {
    NSString *currentWord = [textView.string substringWithRange:charRange];
    BOOL isFirstWord = charRange.location == 0 ? YES : NO;

    NSArray *completions = [self.delegate completionsForWord:currentWord isFirstWord:isFirstWord];

    // Complete immediately if we only have one completion.
    if(completions.count == 1) {
        NSMutableString *text = [textView.string mutableCopy];
        [text deleteCharactersInRange:charRange];
        [text appendString:completions[0]];
        [textView setString:text];
        return @[];
    }

    return completions;
}

@end
