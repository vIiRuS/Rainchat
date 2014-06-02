//
//  MXILoginSheetController.m
//  mxey-IRCCloud
//
//  Created by Maximilian Gaß on 31.05.14.
//  Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//

#import "MXILoginSheetController.h"

@implementation MXILoginSheetController

- (id)init {
    self = [super initWithWindowNibName:@"LoginSheet"];

    return self;
}


- (void)windowDidLoad {
    [super windowDidLoad];

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)buttonClicked:(NSButton *)sender {
    if (self.accountField.stringValue.length > 0 && self.passwordField.stringValue.length > 0) {
        self.account = self.accountField.stringValue;
        self.password = self.passwordField.stringValue;
        [self.window.sheetParent endSheet:self.window];
    }
}

@end
