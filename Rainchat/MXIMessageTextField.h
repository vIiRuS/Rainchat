//
//  MXIMessageTextField.h
//  Rainchat
//
//  Created by Thomas Roth on 07/06/14.
//  Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol MXIMessageTextFieldDelegate <NSTextFieldDelegate>

- (NSArray*)completionsForWord:(NSString*)word isFirstWord:(BOOL)isFirstWord;

@end

@interface MXIMessageTextField : NSTextField <NSTextViewDelegate>

@property(nonatomic) id <MXIMessageTextFieldDelegate> delegate;

@end
