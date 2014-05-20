//
//  MKTextView.m
//  BitMarkets
//
//  Created by Steve Dekorte on 4/23/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKTextView.h"

@implementation MKTextView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _roundRect = [[NavRoundRect alloc] init];
        [_roundRect setFrame:self.bounds];
    }
    
    return self;
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    [self.suffixView removeFromSuperview];
}

- (void)setSuffix:(NSString *)aString
{
    if (!self.suffixView)
    {
        self.suffixView = [[NavTextView alloc] initWithFrame:NSMakeRect(0, 0, 300, self.height)];
        self.suffixView.autoresizingMask = self.autoresizingMask;
        [self.suffixView setEditable:NO];
        [self.suffixView setSelectable:NO];
        [self.superview addSubview:self.suffixView];
    }
    
    self.suffixView.string = aString.strip;
    [self updateSuffixView];
}

- (void)setFrame:(NSRect)frameRect
{
    [super setFrame:frameRect];
    [self updateSuffixView];
    [_roundRect setFrame:self.bounds];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [_roundRect draw];
    [super drawRect:dirtyRect];
}

- (void)updateSuffixView
{
    if (self.suffixView)
    {
        self.suffixView.x = self.textStorage.size.width + /*self.suffixView.textStorage.size.width*/ + 31;
        self.suffixView.y = self.y + self.height - self.suffixView.height;
    }
}

- (BOOL)isReady
{
    return ![self.string isEqualToString:self.uneditedTextString] &&
        ![self.string.strip isEqualToString:@""];
}

- (BOOL)isEmpty
{
    return [self.string.strip isEqualToString:@""];
}

- (void)textShouldBeginEditing
{
    if ([self.string isEqualToString:self.uneditedTextString])
    {
        self.string = @"";
    }
}

- (void)textDidBeginEditing
{
    [self useUneditedTextStringIfNeeded];
}

- (void)useUneditedTextStringIfNeeded
{
    if ([self.string hasPrefix:self.uneditedTextString])
    {
        self.string = [self.string after:self.self.uneditedTextString];
    }
    
    if ([self.string isEqualToString:@""])
    {
        self.string = self.uneditedTextString;
    }
}

- (void)updateTheme
{
    NSString *themePath = nil;
    
    if ([self.string isEqualToString:self.uneditedTextString])
    {
        themePath = [_editedThemePath stringByAppendingString:@"-unedited"];
    }
    else
    {
        themePath = _editedThemePath;
    }
    
    [self setThemePath:themePath];
    [self.suffixView setThemePath:themePath];
    [self.suffixView setHidden:!self.isReady];
    [self setNeedsDisplay:YES];
}


/*
- (void)forceToBeNumber
{
    if (self.lastString && self.string.doubleValue == 0)
    {
        [self.string rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
        self.string = self.lastString;
        NSBeep();
    }
    
    self.lastString = self.string;
}
 */

- (void)setString:(NSString *)aString
{
    if (aString == nil)
    {
        aString = @"";
    }
    
    [super setString:aString];
    [self updateSuffixView];
}

- (void)textDidChange
{
    [self useUneditedTextStringIfNeeded];
    [self updateTheme];
    [self updateSuffixView];
}

- (void)textDidEndEditing
{
}

- (BOOL)becomeFirstResponder
{
    if ([self.string isEqualToString:self.uneditedTextString])
    {
        self.string = @"";
    }

    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    if ([self.string.strip isEqualToString:@""])
    {
        self.string = self.uneditedTextString;
    }
    
    return [super resignFirstResponder];
}

- (NSString *)stringSansUneditedString
{
    return [self.string stringByReplacingOccurrencesOfString:self.uneditedTextString withString:@""];
}

- (void)keyDown:(NSEvent *)theEvent
{
    // go to next keyView on return or tab instead of inserting
    
    unsigned int returnKeyCode = 36;
    unsigned int tabKeyCode    = 48;
    
    unsigned int keyCode = [theEvent keyCode];
    
    if (self.endsOnReturn)
    {
        if (keyCode == returnKeyCode ||
            keyCode == tabKeyCode)
        {
            [self.window makeFirstResponder:self.nextKeyView];
            return;
        }
    }
    
    [super keyDown:theEvent];
}

@end
