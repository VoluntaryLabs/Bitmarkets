//
//  MKActionsView.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKActionsView.h"
#import <NavKit/NavKit.h>
#import "MKRootNode.h"
#import "MKExchangeRate.h"
#import "MKBuyerAddressMsg.h"

@implementation MKActionsView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setAutoresizesSubviews:NO];
        [self setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];

        _group = [[NavColoredView alloc] initWithFrame:NSMakeRect(0, 0, 500, 500)];
        //[_group setBackgroundColor:[NSColor colorWithCalibratedWhite:.5 alpha:1.0]];
        [_group setBackgroundColor:[NSColor clearColor]];
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
    }
}

// sync

- (NavRoundButtonView *)newButton
{
    NavRoundButtonView *button = [[NavRoundButtonView alloc] initWithFrame:NSMakeRect(0, 0, 350, 24)];
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
    for (NSString *action in self.node.actions)
    {
        NavRoundButtonView *button = self.newButton;
        [button setAction:NSSelectorFromString(action)];
        [button setWidth:350];
        [button setHeight:30];
        [button setTitle:action];
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

/*
- (void)hitButton:(id)sender
{

    
}
*/

- (BOOL)handlesNodeActions
{
    return YES;
}


@end
