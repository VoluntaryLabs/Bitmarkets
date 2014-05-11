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
#import "MKBuyerAddressMsg.h"

@implementation MKDeliveryAddressView

- (NavTextView *)newLabel
{
    NavTextView *label = [[NavTextView alloc] initWithFrame:NSMakeRect(0, 0, 350, 24)];
    [_group addSubview:label];
    [label setThemePath:@"address/label"];
    //[label setThemePath:@"address/line"];
    [label setDelegate:self];
    [label setEditable:NO];
    return label;
}

- (MKTextView *)newLine
{
    MKTextView *line = [[MKTextView alloc] initWithFrame:NSMakeRect(0, 0, 350, 24)];
    //line.uneditedTextString = @"";
    [_group addSubview:line];
    [line setEditedThemePath:@"address/line"];
    [line setDelegate:self];
    line.endsOnReturn = YES;
    return line;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setAutoresizesSubviews:NO];
        [self setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];

        _group = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 500, 500)];
        [self addSubview:_group];
        
        _label1 = self.newLabel;
        _label2 = self.newLabel;
        _label3 = self.newLabel;
        _label4 = self.newLabel;

        _label1.string = @"Name of addressee";
        _label2.string = @"Street address or post office box number";
        _label3.string = @"City name, province/state/county, postal code";
        _label4.string = @"Full country name";
        
        _line1 = self.newLine;
        _line2 = self.newLine;
        _line3 = self.newLine;
        _line4 = self.newLine;

        /*
        _line1.uneditedTextString = @"Name of addressee";
        _line2.uneditedTextString = @"Street address or post office box number";
        _line3.uneditedTextString = @"City name, province/state/county, postal code";
        _line4.uneditedTextString = @"Full country name";
        */
        
        _line1.uneditedTextString = @"Name";
        _line2.uneditedTextString = @"Address Line 1";
        _line3.uneditedTextString = @"Address Line 2";
        _line4.uneditedTextString = @"Country";
        
        _line1.nextKeyView = _line2;
        _line2.nextKeyView = _line3;
        _line3.nextKeyView = _line4;
        _line4.nextKeyView = _line1;
        
        /*
        //_line1.height = 160;
        _line1.roundRect.isOutlined = YES;
        _line1.roundRect.outlineWidth = 1;
        _line1.roundRect.outlineColor = [NSColor colorWithCalibratedWhite:0.95 alpha:1.0];
        */
        
        _doneButton = [[NavRoundButtonView alloc] initWithFrame:NSMakeRect(0, 0, 120, 32)];
        //_postOrBuyButton.title = @"Buy Now";
        _doneButton.title = @"Send this Address to Seller";
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
    CGFloat labelMargin = 0;
    CGFloat lineMargin = 33;

    [_label4 setX:0];
    [_label3 setX:0];
    [_label2 setX:0];
    [_label1 setX:0];
    
    [_line4 setX:0];
    [_line3 setX:0];
    [_line2 setX:0];
    [_line1 setX:0];

    /*
    [_line4 setY:0];
    [_line3 placeYAbove:_line4 margin:m];
    [_line2 placeYAbove:_line3 margin:m];
    [_line1 placeYAbove:_line2 margin:m];
    */
    
    [_label1 setY:0];
    [_line1 placeYBelow:_label1 margin:labelMargin];
    
    [_label2 placeYBelow:_line1 margin:lineMargin];
    [_line2 placeYBelow:_label2 margin:labelMargin];
    
    [_label3 placeYBelow:_line2 margin:lineMargin];
    [_line3 placeYBelow:_label3 margin:labelMargin];
    
    [_label4 placeYBelow:_line3 margin:lineMargin];
    [_line4 placeYBelow:_label4 margin:labelMargin];
    

    [_group sizeAndRepositionSubviewsToFit];
    [_group centerXInSuperview];
    [_group centerYInSuperview];
    [_group setY:_group.y + 60];
    //[_doneButton centerXInSuperview];
    _doneButton.width = 250;
    [_doneButton setX:_group.x + 7];
    [_doneButton placeYBelow:_group margin:lineMargin*1.4];
    
    [self updateButton];
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
    [self setDict:self.deliveryAddress.addressDict];
    [self updateButton];
}

- (void)syncToNode
{
    [self.deliveryAddress setAddressDict:[NSMutableDictionary dictionaryWithDictionary:self.dict]];
    [self.deliveryAddress postSelfChanged];
    [self.deliveryAddress write];
}

- (BOOL)isReady
{
    return self.deliveryAddress.canSend;
    /*
        self.line1.isReady &&
        self.line2.isReady &&
        self.line3.isReady &&
        self.line4.isReady;
    */
}

- (void)updateButton
{
    NSDictionary *enabledAttributes  = [NavTheme.sharedNavTheme attributesDictForPath:@"sell/button"];
    NSDictionary *disabledAttributes = [NavTheme.sharedNavTheme attributesDictForPath:@"sell/button-disabled"];

    if (self.deliveryAddress.isInBuy)
    {
        [_doneButton setHidden:NO];

        if (self.deliveryAddress.canSend)
        {
            [_doneButton setTitleAttributes:enabledAttributes];
            [_doneButton setEnabled:YES];
        }
        else
        {
            [_doneButton setTitleAttributes:disabledAttributes];
            [_doneButton setEnabled:NO];
        }
    }
    else
    {
        [_doneButton setHidden:YES];
    }
    
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
    //NSLog(@"done");
    [self.deliveryAddress sendMsg];
}

@end
