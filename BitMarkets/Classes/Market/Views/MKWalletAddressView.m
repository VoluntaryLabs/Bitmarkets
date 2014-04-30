//
//  MKWalletAddressView.m
//  BitMarkets
//
//  Created by Steve Dekorte on 4/29/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <BitnashKit/BitnashKit.h>
#import <NavKit/NavKit.h>
#import "MKWalletAddressView.h"

@implementation MKWalletAddressView

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
        
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    [[NSColor whiteColor] set];
    NSRectFill(dirtyRect);
}

- (void)setNode:(MKWalletAddress *)node
{
    _node = node;
    
    self.qrCodeImageView.image = [QRCodeGenerator qrImageForString:node.address imageSize:_qrWidth];
    self.qrCodeTextView.string = node.address;
    [_qrCodeTextView setThemePath:@"qr/address"];
    [_qrCodeTextView setEditable:NO];
    
    [self layout];
}

- (void)setFrame:(NSRect)frameRect
{
    [super setFrame:frameRect];
    [self layout];
}

- (void)layout
{
    [self.qrCodeImageView centerXInSuperview];
    [self.qrCodeImageView centerYInSuperview];
    [self.qrCodeTextView placeYBelow:self.qrCodeImageView margin:20];
    [self.qrCodeTextView centerXInSuperview];
    [self setNeedsDisplay:YES];
}

@end
