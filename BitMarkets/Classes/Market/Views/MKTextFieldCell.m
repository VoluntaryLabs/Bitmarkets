//
//  MKTextFieldCell.m
//  BitMarkets
//
//  Created by Steve Dekorte on 7/1/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKTextFieldCell.h"

@implementation MKTextFieldCell

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.marginLeft = 10.0;
        self.marginRight = 10.0;
        self.lineColor = [NSColor colorWithCalibratedWhite:.8 alpha:1.0];
    }
    
    return self;
}

- (NSRect)drawingRectForBounds:(NSRect)rect
{
    return [self titleRectForBounds:rect];
}

- (NSRect)titleRectForBounds:(NSRect)rect
{
    NSRect rectInset = NSMakeRect(
                                  rect.origin.x + self.marginLeft,
                                  rect.origin.y + _marginBottom,
                                  rect.size.width - self.marginLeft - self.marginRight,
                                  rect.size.height - self.marginBottom - self.marginTop);

    // vertically center
    NSSize titleSize = [[self attributedStringValue] size];
    rectInset.origin.y += (rectInset.size.height - titleSize.height)/2.0 - 0.5;
    
    return [super drawingRectForBounds:rectInset];
}


- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    [super drawInteriorWithFrame:cellFrame inView:controlView];
    
    if (self.bottomLineWidth)
    {
        CGFloat x = cellFrame.origin.x;
        CGFloat y = cellFrame.origin.y;
        CGFloat h = cellFrame.size.height;
        CGFloat w = cellFrame.size.width;
        
        [self.lineColor set];
        
        [NSBezierPath setDefaultLineCapStyle:NSButtLineCapStyle];
        
        NSBezierPath *aPath = [NSBezierPath bezierPath];
        [aPath setLineWidth:self.bottomLineWidth];
        [aPath moveToPoint:NSMakePoint(x, y+h)];
        [aPath lineToPoint:NSMakePoint(x+w, y+h)];
        [aPath setLineCapStyle:NSSquareLineCapStyle];
        [aPath stroke];
    }
}

- (void)highlight:(BOOL)flag withFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    /*
	[super drawRect:dirtyRect];
    [[NSColor whiteColor] set];
    NSRectFill(dirtyRect);
    
    [self drawInteriorWithFrame:cellFrame inView:controlView];
    */
}




@end
