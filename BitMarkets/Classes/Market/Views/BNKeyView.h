//
//  MKWalletAddressView.h
//  BitMarkets
//
//  Created by Steve Dekorte on 4/29/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MKWalletAddress.h"

@interface BNKeyView : NSView

@property (strong, nonatomic) BNKey *node;
@property (strong, nonatomic) NavView *navView;
@property (strong, nonatomic) NSImageView *qrCodeImageView;
@property (strong, nonatomic) NSTextView *qrCodeTextView;
@property (assign, nonatomic) CGFloat qrWidth;

@end
