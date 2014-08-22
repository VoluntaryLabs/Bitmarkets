//
//  MKPanelView.m
//  BitMarkets
//
//  Created by Steve Dekorte on 6/16/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKPanelView.h"

@implementation MKPanelView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setAutoresizesSubviews:YES];
        [self setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];
    }
    
    return self;
}

- (BOOL)isOpaque
{
    return NO;
}

- (void)setFrame:(NSRect)frameRect
{
    [super setFrame:frameRect];
    [self layout];
}

- (void)setInnerView:(NavMirrorView *)innerView
{
    if (innerView != _innerView)
    {
        [_innerView removeFromSuperview];
        _innerView = innerView;
        [self addSubview:_innerView];
        [self layout];
        
        [self setLayer:[CALayer new]];
        [self setWantsLayer:YES];
        self.layer.backgroundColor = [[NSColor colorWithCalibratedWhite:.95 alpha:0.85] CGColor];
        
        //[_innerView setLayer:[CALayer new]];
        //[_innerView setWantsLayer:YES];
        //_innerViewlayer.backgroundColor = [[NSColor colorWithCalibratedWhite:1.0 alpha:1.0] CGColor];
        
        NSShadow *dropShadow = [[NSShadow alloc] init];
        [dropShadow setShadowColor:[NSColor colorWithCalibratedWhite:.7 alpha:1.0]];
        [dropShadow setShadowOffset:NSMakeSize(0, 0)];
        [dropShadow setShadowBlurRadius:3.0];
        
        [_innerView setWantsLayer:YES];
        [_innerView setShadow:dropShadow];
        
        
        [NSNotificationCenter.defaultCenter addObserver:self
                                                 selector:@selector(sentNavAction:)
                                                     name:@"SentNavAction"
                                                   object:innerView.node];
        
    }
}

- (void)sentNavAction:(NSNotification *)aNote
{
    [self close];
}

- (void)layout
{
    if (self.superview)
    {
        [self setX:0];
        [self setY:0];
        [self setWidth:self.superview.width];
        [self setHeight:self.superview.height];
        
        [_innerView setWidth: self.width  * .5];
        [_innerView setHeight:self.height * .7];
        
        [_innerView centerXInSuperview];
        [_innerView centerYInSuperview];
        //[self.window setOpaque:NO];
    }
}

/*
- (void)drawRect:(NSRect)dirtyRect
{
    //[super drawRect:dirtyRect];
    
    NSColor *backgroundColor = [NSColor colorWithCalibratedWhite:.95 alpha:0.8];
    [backgroundColor setFill];
    //[backgroundColor set];
    //NSRectFill(dirtyRect);
    NSRectFillUsingOperation(dirtyRect, NSCompositeSourceOver);
}
*/

- (void)mouseDown:(NSEvent *)theEvent
{
    NSPoint p = [self convertPoint:theEvent.locationInWindow fromView:nil];
    
    if (![_innerView hitTest:p])
    {
        [self close];
    }
}

- (void)close
{
    [self removeFromSuperview];
}

@end
