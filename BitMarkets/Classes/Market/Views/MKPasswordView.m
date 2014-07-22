//
//  MKPasswordView.m
//  BitMarkets
//
//  Created by Steve Dekorte on 7/20/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKPasswordView.h"

@implementation MKPasswordView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _info = [[NavTextView alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
        [_info setThemePath:@"password/info"];
        [self addSubview:_info];
        
        _password = [[NSSecureTextField alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
        [_password setThemePath:@"password/password"];
        [self addSubview:_password];
        
        _passwordConfirm = [[NSSecureTextField alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
        [_passwordConfirm setThemePath:@"password/password"];
        [self addSubview:_passwordConfirm];
    }
    
    return self;
}

- (BOOL)hasPassword
{
    return NO;
}

- (void)setup
{
    [_passwordConfirm setHidden:self.hasPassword];
    
    if (!self.hasPassword)
    {
        [_info setString:@"Please choose a password"];
        [_passwordConfirm setHidden:NO];
        [self.window makeFirstResponder:_password];
    }
    else
    {
        [_passwordConfirm setHidden:YES];
    }
}

- (void)layout
{
    [_password centerXInSuperview];
    [_password centerYInSuperview];
    
    [_info centerXInSuperview];
    [_info placeYAbove:_password margin:20];
    
    [_passwordConfirm placeYBelow:_password margin:20];
}

@end
