//
//  MKPasswordView.h
//  BitMarkets
//
//  Created by Steve Dekorte on 7/20/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <NavKit/NavKit.h>

@interface MKPasswordView : NSView

@property (strong, nonatomic) NavTextView *info;
@property (strong, nonatomic) NSSecureTextField *password;
@property (strong, nonatomic) NSSecureTextField *passwordConfirm;

@end
