//
//  MKWalletAddressView.m
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
        
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    [[NSColor whiteColor] set];
    NSRectFill(dirtyRect);
}

- (void)setNode:(BNKey *)node
{
    _node = node;
    
    NSString *addressString = node.address;
    self.qrCodeImageView.image = [QRCodeGenerator qrImageForString:addressString imageSize:_qrWidth];
    self.qrCodeTextView.string = addressString;
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
