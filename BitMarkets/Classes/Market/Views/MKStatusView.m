//
//  MKStatusView.m
//  BitMarkets
//
//  Created by Steve Dekorte on 6/12/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKStatusView.h"
#import "MKTransaction.h"
#import "MKPostView.h"

@implementation MKStatusView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _statusTextView   = [[NavTextView alloc] initWithFrame:NSMakeRect(0, 0, 100, 30)];
        [_statusTextView setThemePath:@"steps/status/title"];
        [self addSubview:_statusTextView];
        
        _subtitleTextView = [[NavTextView alloc] initWithFrame:NSMakeRect(0, 0, 100, 30)];
        [_subtitleTextView setThemePath:@"steps/status/subtitle"];
        [self addSubview:_subtitleTextView];
    }
    
    return self;
}

- (void)setNode:(NavNode *)node
{
    _node = node;
    
    _statusTextView.string = self.transaction.statusTitle;
    
    _subtitleTextView.string = self.transaction.statusSubtitle;
    
    [self syncToNode];
}

- (MKTransaction *)transaction
{
    return (MKTransaction *)self.node;
}

- (void)syncToNode
{
    self.backgroundColor = [self.nodeTitleAttributes objectForKey:NSBackgroundColorAttributeName];
    [self layout];
}

- (void)layout
{
    //[_statusTextView setX:[[MKPostView class] leftMargin]];
    [_statusTextView setX:MKPostView.leftMargin];
    [_statusTextView setWidth:self.width];
    [_statusTextView setY:self.height - _statusTextView.height - 30];
    
    [_subtitleTextView setX:_statusTextView.x];
    [_subtitleTextView setWidth:_statusTextView.width];
    [_subtitleTextView placeYBelow:_statusTextView margin:0.0];
}

- (NSDictionary *)nodeTitleAttributes
{
    return [[NavTheme sharedNavTheme] attributesDictForPath:@"steps/step"];
}


- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];

    [self drawHorizontalLineAtY:self.height];
    [self drawHorizontalLineAtY:0];
}

- (void)drawHorizontalLineAtY:(CGFloat)y
{
    [[NSColor colorWithCalibratedWhite:.7 alpha:1.0] set];
    
    [NSBezierPath setDefaultLineCapStyle:NSButtLineCapStyle];
    
    NSBezierPath *aPath = [NSBezierPath bezierPath];
    [aPath moveToPoint:NSMakePoint(0.0, y)];
    [aPath lineToPoint:NSMakePoint(self.width, y)];
    [aPath setLineCapStyle:NSSquareLineCapStyle];
    [aPath stroke];
}


@end
