//
//  BNKeyView.m
//  BitMarkets
//
//  Created by Steve Dekorte on 4/29/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <BitnashKit/BitnashKit.h>
#import <NavKit/NavKit.h>
#import "BNKeyView.h"

@implementation BNKeyView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setAutoresizesSubviews:YES];
        [self setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];
        
        self.qrWidth = 512;
        self.qrCodeImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, _qrWidth, _qrWidth)];
        [self addSubview:self.qrCodeImageView];

        self.qrCodeTextView = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, _qrWidth, 20)];
        [self addSubview:self.qrCodeTextView];
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(syncToNode) name:nil object:self.node];
    }
    
    return self;
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)syncToNode
{
    NSLog(@"_node.address = %@", _node.address);
    
    self.qrCodeImageView.image = [QRCodeGenerator qrImageForString:_node.address imageSize:_qrWidth];
    self.qrCodeTextView.string = _node.address;
    [_qrCodeTextView setThemePath:@"qr/address"];
    [_qrCodeTextView setEditable:NO];
    [_qrCodeTextView setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    [[NSColor whiteColor] set];
    NSRectFill(dirtyRect);
}

- (void)setNode:(BNKey *)node
{
    if (_node != node)
    {
        [NSNotificationCenter.defaultCenter removeObserver:self name:nil object:_node];
        _node = node;
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(syncToNode) name:nil object:_node];
        [self syncToNode];
    }
    
    [self layout];
}

- (void)setFrame:(NSRect)frameRect
{
    [super setFrame:frameRect];
    [self layout];
}

- (void)layout
{
    CGFloat minx = self.superview.width/2;
    CGFloat miny = self.superview.height/2;
    CGFloat min = minx < miny ? minx : miny;
    
    [self.qrCodeImageView setHeight:min];
    [self.qrCodeImageView setWidth:min];
    
    [self.qrCodeImageView centerXInSuperview];
    [self.qrCodeImageView centerYInSuperview];
    [self.qrCodeTextView placeYBelow:self.qrCodeImageView margin:20];
    [self.qrCodeTextView centerXInSuperview];
    [self setNeedsDisplay:YES];
}

@end
