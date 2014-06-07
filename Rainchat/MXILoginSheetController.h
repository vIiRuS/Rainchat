//
//  MXILoginSheetController.h
//  Rainchat
//
//  Created by Maximilian Gaß on 31.05.14.
//  Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//



@class MXIAppDelegate;

@interface MXILoginSheetController : NSWindowController
@property(weak) IBOutlet NSTextField *accountField;
@property(weak) IBOutlet NSSecureTextField *passwordField;

@property(nonatomic, copy) NSString *password;
@property(nonatomic, copy) NSString *account;
@end
