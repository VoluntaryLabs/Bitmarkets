//
//  MKDeliveryAddressView.h
//  Bitmessage
//
//  Created by Steve Dekorte on 2/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <NavKit/NavKit.h>
#import "MKBuyDeliveryAddress.h"

@interface MKDeliveryAddressView : NSView <NSTextViewDelegate>

@property (assign, nonatomic) NavView *navView;
@property (assign, nonatomic) NavNode *node;

@property (strong, nonatomic) NSView *group;

@property (strong, nonatomic) NavTextView *label1;
@property (strong, nonatomic) NavTextView *label2;
@property (strong, nonatomic) NavTextView *label3;
@property (strong, nonatomic) NavTextView *label4;

@property (strong, nonatomic) NavAdvTextView *line1;
@property (strong, nonatomic) NavAdvTextView *line2;
@property (strong, nonatomic) NavAdvTextView *line3;
@property (strong, nonatomic) NavAdvTextView *line4;

@property (strong, nonatomic) NavRoundButtonView *doneButton;
@property (strong, nonatomic) NavColoredView *separator;

@property (assign, nonatomic) BOOL isUpdating;

- (MKBuyDeliveryAddress *)deliveryAddress;

- (void)prepareToDisplay;
- (void)selectFirstResponder;

@end
