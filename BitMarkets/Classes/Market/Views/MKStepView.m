//
//  MKStepView.m
//  BitMarkets
//
//  Created by Steve Dekorte on 6/12/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKStepView.h"
#import "MKPostView.h"
#import "MKBuyBid.h"

@implementation MKStepView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [NSColor whiteColor];
    }
    
    return self;
}

- (void)syncToNode
{
    self.backgroundColor = [self.nodeTitleAttributes objectForKey:NSBackgroundColorAttributeName];
}

- (NSDictionary *)nodeTitleAttributes
{
    return [[NavTheme sharedNavTheme] attributesDictForPath:@"steps/step"];
}

- (void)drawRect:(NSRect)dirtyRect
{
    CGFloat yOffset = 5;
    
    [super drawRect:dirtyRect];
    [self drawBackground];
    
    NSDictionary *att = [self nodeTitleAttributes];
    CGFloat fontSize = [(NSFont *)[att objectForKey:NSFontAttributeName] pointSize];

    // draw title
    {
        NSString *title = self.node.nodeTitle;
        //CGFloat titleWidth = [[[NSAttributedString alloc] initWithString:title attributes:att] size].width;
        
        //[title drawAtPoint:NSMakePoint(self.bounds.origin.x + self.bounds.size.width/2.0 - titleWidth/2.0,
//        [title drawAtPoint:NSMakePoint(self.bounds.origin.x + self.bounds.size.width/4.0,
        CGFloat margin = MKPostView.leftMargin;
        [title drawAtPoint:NSMakePoint(self.bounds.origin.x + margin + 5,
                                       self.bounds.origin.y + self.bounds.size.height/2.0 - fontSize/2.0 - yOffset)
            withAttributes:att];
    }
    
    // draw status
    NSString *nodeNote = self.node.nodeNote;
    if (nodeNote)
    {
        [nodeNote drawAtPoint:NSMakePoint(self.bounds.size.width - self.width*.2,
                                       self.bounds.origin.y + self.bounds.size.height/2.0 - fontSize/2.0 - yOffset)
            withAttributes:att];
    }
}

- (MKStage *)stage
{
    return (MKStage *)self.node;
}

- (void)drawBackground
{
    if (self.stage.isComplete)
    {
        [self drawFillArrow];
    }
    
    if (self.hasArrow)
    {
        [self drawArrowLine];
    }
}

- (BOOL)hasArrow
{
    return (self.superview.subviews.lastObject != self);
}

- (void)drawArrowLine
{
    [[NSColor colorWithCalibratedWhite:.8 alpha:1.0] set];
    
    [NSBezierPath setDefaultLineCapStyle:NSButtLineCapStyle];
    
    CGFloat right = 10.0;
    CGFloat w = self.width;
    CGFloat h = self.height;
    
    NSBezierPath *aPath = [NSBezierPath bezierPath];
    [aPath moveToPoint:NSMakePoint(w - right, 0)];
    [aPath lineToPoint:NSMakePoint(w, h/2)];
    [aPath lineToPoint:NSMakePoint(w- right, h)];
    [aPath setLineCapStyle:NSSquareLineCapStyle];
    [aPath setLineJoinStyle:kCGLineJoinRound];
    [aPath stroke];
}

- (BOOL)shouldFillRightSide
{
    MKStage *nextStage = self.stage.nextStage;
    
    if (nextStage && nextStage.isComplete)
    {
        return YES;
    }
    
    return NO;
}

- (void)drawFillArrow
{
    if (self.stage.isActive && !self.stage.isComplete)
    {
        [[NSColor colorWithCalibratedWhite:.9 alpha:1.0] set];
    }
    else
    {
        [[NSColor colorWithCalibratedWhite:.97 alpha:1.0] set];
    }
    
    [NSBezierPath setDefaultLineCapStyle:NSButtLineCapStyle];
    
    CGFloat right = 10.0;
    CGFloat w = self.width;
    CGFloat h = self.height;
    
    NSBezierPath *aPath = [NSBezierPath bezierPath];
    
    [aPath moveToPoint:NSMakePoint(0, 0)];
    
    if (self.hasArrow && !self.shouldFillRightSide)
    {
        [aPath lineToPoint:NSMakePoint(w - right, 0)];
        [aPath lineToPoint:NSMakePoint(w, h/2)];
        [aPath lineToPoint:NSMakePoint(w- right, h)];
    }
    else
    {
        [aPath lineToPoint:NSMakePoint(w, 0)];
        [aPath lineToPoint:NSMakePoint(w, h)];
    }
    
    [aPath lineToPoint:NSMakePoint(0, h)];
    [aPath lineToPoint:NSMakePoint(0, 0)];
    
    [aPath setLineCapStyle:NSSquareLineCapStyle];
    [aPath closePath];
    [aPath fill];
}

@end
