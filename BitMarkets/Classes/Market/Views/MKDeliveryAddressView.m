//
//  MKDeliveryAddressView.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKDeliveryAddressView.h"
#import <NavKit/NavKit.h>
#import "MKRootNode.h"
#import "MKExchangeRate.h"

@implementation MKDeliveryAddressView

- (MKTextView *)newLine
{
    MKTextView *line = [[MKTextView alloc] initWithFrame:NSMakeRect(0, 0, 500, 24)];
    line.uneditedTextString = @"Name of Addressee";
    [_group addSubview:line];
    [line setEditedThemePath:@"address/label"];
    [line setDelegate:self];
    line.endsOnReturn = YES;
    return line;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setAutoresizesSubviews:YES];
        [self setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];

        _group = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 500, 500)];
        [self addSubview:_group];
        
        _line1 = self.newLine;
        _line2 = self.newLine;
        _line3 = self.newLine;
        _line4 = self.newLine;

        _line1.uneditedTextString = @"Name of addressee";
        _line2.uneditedTextString = @"Street address or post office box number";
        _line3.uneditedTextString = @"City name, province/state/county, postal code";
        _line4.uneditedTextString = @"Full country name";
        
        _line1.nextKeyView = _line2;
        _line2.nextKeyView = _line3;
        _line3.nextKeyView = _line4;
        _line4.nextKeyView = _line1;
        
        _doneButton = [[NavRoundButtonView alloc] initWithFrame:NSMakeRect(0, 0, 120, 32)];
        //_postOrBuyButton.title = @"Buy Now";
        _doneButton.title = @"Done";
        //[_postOrBuyButton setThemePath:@"sell/button"];
        [_doneButton setTitleAttributes:[NavTheme.sharedNavTheme attributesDictForPath:@"sell/button"]];
        [self addSubview:_doneButton];
        [_doneButton setTarget:self];
        [_doneButton setAction:@selector(done)];
        
        /*
        self.separator = [[NavColoredView alloc] initWithFrame:NSMakeRect(0, 0, self.width, 1)];
        [self.separator setThemePath:@"sell/separator"];
        [self addSubview:self.separator];
         */
    }
    
    return self;
}

- (void)layout
{
    CGFloat m = 30;
    
    [_line4 setX:0];
    [_line3 setX:0];
    [_line2 setX:0];
    [_line1 setX:0];
    
    [_line4 setY:0];
    [_line3 placeYAbove:_line4 margin:m];
    [_line2 placeYAbove:_line3 margin:m];
    [_line1 placeYAbove:_line2 margin:m];

    [_group sizeAndRepositionSubviewsToFit];
    [_group centerXInSuperview];
    [_group centerYInSuperview];
    [_doneButton centerXInSuperview];
    [_doneButton placeYBelow:_group margin:m];
}

- (void)prepareToDisplay
{
    [self layout];
    [self layout];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setFrame:(NSRect)frameRect
{
    [super setFrame:frameRect];
    [self layout];
}

- (void)setNode:(NavNode *)node
{
    _node = node;
    [self syncFromNode];
}

- (MKBuyDeliveryAddress *)deliveryAddress
{
    return (MKBuyDeliveryAddress *)self.node;
}

// dict

- (NSDictionary *)dict
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.line1.stringSansUneditedString forKey:@"line1"];
    [dict setObject:self.line2.stringSansUneditedString forKey:@"line2"];
    [dict setObject:self.line3.stringSansUneditedString forKey:@"line3"];
    [dict setObject:self.line4.stringSansUneditedString forKey:@"line4"];
    return dict;
}

- (void)setDict:(NSDictionary *)dict
{
    _line1.string = [dict objectForKey:@"line1"];
    _line2.string = [dict objectForKey:@"line2"];
    _line3.string = [dict objectForKey:@"line3"];
    _line4.string = [dict objectForKey:@"line4"];
    
    [_line1 textDidChange];
    [_line1 useUneditedTextStringIfNeeded];
    
    [_line2 textDidChange];
    [_line2 useUneditedTextStringIfNeeded];
    
    [_line3 textDidChange];
    [_line3 useUneditedTextStringIfNeeded];
    
    [_line4 textDidChange];
    [_line4 useUneditedTextStringIfNeeded];
}

// sync

- (void)syncFromNode
{
    [self setDict:self.deliveryAddress.dict];
    [self updateButton];
}

- (void)syncToNode
{
    [self.deliveryAddress setDict:self.dict];
    [self.deliveryAddress postSelfChanged];
}

- (BOOL)isReady
{
    return
        self.line1.isReady &&
        self.line2.isReady &&
        self.line3.isReady &&
        self.line4.isReady;
}

- (void)updateButton
{
    NSDictionary *enabledAttributes = [NavTheme.sharedNavTheme attributesDictForPath:@"sell/button"];
    NSDictionary *disabledAttributes = [NavTheme.sharedNavTheme attributesDictForPath:@"sell/button-disabled"];

    [_doneButton setHidden:NO];
    [_doneButton setEnabled:YES];


    
    [_doneButton setNeedsDisplay:YES];
}

- (MKSell *)sell
{
    return (MKSell *)self.node;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    [[NSColor whiteColor] set];
    NSRectFill(dirtyRect);
}

// --- editing ---------------------------------------------------

- (void)textDidChange:(NSNotification *)aNotification
{
    NSTextView *aTextView = [aNotification object];
    
    if ([aTextView respondsToSelector:@selector(textDidChange)])
    {
        [(MKTextView *)aTextView textDidChange];
    }
    
    [self updateButton];
    [self syncToNode]; // to show on table cell
    [self layout];
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)aTextView
{
    if ([aTextView respondsToSelector:@selector(textDidBeginEditing)])
    {
        [(MKTextView *)aTextView textShouldBeginEditing];
    }
    
    return YES;
}

- (void)textDidBeginEditing:(NSText *)aTextView
{
    if ([aTextView respondsToSelector:@selector(textDidBeginEditing)])
    {
        [(MKTextView *)aTextView textDidBeginEditing];
    }
}

- (void)textDidEndEditing:(NSNotification *)aNotification
{
    NSTextView *aTextView = [aNotification object];
    
    if ([aTextView respondsToSelector:@selector(textDidEndEditing)])
    {
        [(MKTextView *)aTextView textDidEndEditing];
    }
    
    [[aNotification object] endEditing];
    [self saveChanges];
    [self updateButton];
}

- (void)saveChanges
{
}

// -- sync ----

- (void)selectFirstResponder
{
    //[self.window makeFirstResponder:self.labelField];
    //[self.labelField selectAll:nil];
    //[labelField becomeFirstResponder];
}

// actions

- (void)done
{
    NSLog(@"done");
}

@end
