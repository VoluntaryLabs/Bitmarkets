//
//  MKMirrorView.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKMirrorView.h"
#import <NavKit/NavKit.h>
#import "MKRootNode.h"
#import "MKExchangeRate.h"
#import "MKBuyerAddressMsg.h"

@implementation MKMirrorView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setAutoresizesSubviews:NO];
        [self setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];

        _group = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 500, 500)];
        //[_group setBackgroundColor:[NSColor colorWithCalibratedWhite:.5 alpha:1.0]];
        //[_group setBackgroundColor:[NSColor clearColor]];
        [self addSubview:_group];        
    }
    
    return self;
}

- (void)layout
{
    //[_group stackSubviewsTopToBottomWithMargin:10.0];
    [_group stackSubviewsBottomToTopWithMargin:10.0];
    
    [_group sizeAndRepositionSubviewsToFit];
    [_group centerXInSuperview];
    [_group centerYInSuperview];
    [_group setY:_group.y + 30];
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
    [self prepareToDisplay];
}

- (void)setNode:(NavNode *)node
{
    if (_node != node)
    {
        _node = node;
        [self syncFromNode];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(nodeChanged:)
                                                     name:nil
                                                   object:_node];
    }
}

- (void)nodeChanged:(NSNotification *)note
{
    [self syncFromNode];
}

// sync

- (NavRoundButtonView *)newButton
{
    NavRoundButtonView *button = [[NavRoundButtonView alloc] initWithFrame:NSMakeRect(0, 0, 350, 24)];
    [button setCornerRadius:6];
    //line.uneditedTextString = @"";
    [_group addSubview:button];
    [button setTarget:self.node];
    //[button setAction:@selector(hitButton:)];
    
    button.title = @"default";
    //[button setThemePath:@"sell/button"];
    [button setTitleAttributes:[NavTheme.sharedNavTheme attributesDictForPath:@"sell/button"]];
    
    return button;
}

- (void)syncFromNode
{
    [_group removeAllSubviews];

    for (NavDataSlot *dataSlot in self.node.navMirror.dataSlots)
    {
        NSView *slotView = dataSlot.slotView;
        
        if (slotView)
        {
            [_group addSubview:slotView];
            
            //_line1.uneditedTextString = @"Name";
            //_label1.string = @"Name of addressee";
          
            //    [_line1 useUneditedTextStringIfNeeded];

        }
    }
    
    for (NavActionSlot *actionSlot in self.node.navMirror.actionSlots)
    {
        NavRoundButtonView *button = self.newButton;
        [button setAction:NSSelectorFromString(actionSlot.name)];
        [button setWidth:350];
        [button setHeight:30];
        [button setTitle:actionSlot.visibleName];
        
        if (!actionSlot.isActive)
        {
            [button setTitleAttributes:[NavTheme.sharedNavTheme attributesDictForPath:@"sell/button-disabled"]];
            [button setEnabled:NO];
        }
        
        [_group addSubview:button];
    }
    
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    [[NSColor whiteColor] set];
    NSRectFill(dirtyRect);
}

// -- sync ----

- (void)selectFirstResponder
{
    //[self.window makeFirstResponder:self.labelField];
    //[self.labelField selectAll:nil];
    //[labelField becomeFirstResponder];
}

// actions

/*
- (void)hitButton:(id)sender
{

    
}
*/

- (BOOL)handlesNodeActions
{
    return YES;
}

// --- text -------------------------------------------

- (void)updateActions
{
    
}

- (void)syncToNode
{
    
}


- (void)textDidChange:(NSNotification *)aNotification
{
    NSTextView *aTextView = [aNotification object];
    
    if ([aTextView respondsToSelector:@selector(textDidChange)])
    {
        [(NavAdvTextView *)aTextView textDidChange];
    }
    
    [self updateActions];
    [self syncToNode]; // to show on table cell
    [self layout];
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)aTextView
{
    if ([aTextView respondsToSelector:@selector(textDidBeginEditing)])
    {
        [(NavAdvTextView *)aTextView textShouldBeginEditing];
    }
    
    return YES;
}

- (void)textDidBeginEditing:(NSText *)aTextView
{
    if ([aTextView respondsToSelector:@selector(textDidBeginEditing)])
    {
        [(NavAdvTextView *)aTextView textDidBeginEditing];
    }
}

- (void)textDidEndEditing:(NSNotification *)aNotification
{
    NSTextView *aTextView = [aNotification object];
    
    if ([aTextView respondsToSelector:@selector(textDidEndEditing)])
    {
        [(NavAdvTextView *)aTextView textDidEndEditing];
    }
    
    [[aNotification object] endEditing];
    [self syncToNode];
    [self updateActions];
}

@end
