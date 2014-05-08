//
//  MKTextView.h
//  BitMarkets
//
//  Created by Steve Dekorte on 4/23/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <NavKit/NavKit.h>

@interface MKTextView : NavTextView

@property (strong, nonatomic) NSString *editedThemePath;
@property (strong, nonatomic) NSString *uneditedTextString;
@property (strong, nonatomic) NavTextView *suffixView;
@property (assign, nonatomic) BOOL endsOnReturn;
@property (strong, nonatomic) NSString *lastString;

@property (strong, nonatomic) NavRoundRect *roundRect;

- (void)setSuffix:(NSString *)aString;

- (void)useUneditedTextStringIfNeeded;

- (void)textShouldBeginEditing;
- (void)textDidBeginEditing;
- (void)textDidChange;
- (void)textDidEndEditing;

- (BOOL)isReady;

- (NSString *)stringSansUneditedString;

@end
