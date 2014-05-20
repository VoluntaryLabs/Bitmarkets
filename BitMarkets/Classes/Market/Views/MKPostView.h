//
//  BMAddressedView.h
//  Bitmessage
//
//  Created by Steve Dekorte on 2/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <NavKit/NavKit.h>
#import "MKSell.h"
#import "MKTextView.h"
#import "MKExchangeRate.h"
#import "MKAttachmentView.h"

@interface MKPostView : NSView <NSTextViewDelegate>

@property (assign, nonatomic) NavView *navView;
@property (assign, nonatomic) NavNode *node;

@property (strong, nonatomic) MKTextView *title;
//@property (strong, nonatomic) IBOutlet NSTextView *quantity;
@property (strong, nonatomic) MKTextView *price;
@property (strong, nonatomic) NavRoundButtonView *postOrBuyButton;

@property (strong, nonatomic) NavColoredView *separator;

@property (strong, nonatomic) MKTextView *description;

@property (strong, nonatomic) NSImageView *regionIcon;
@property (strong, nonatomic) NSTextView *region;

@property (strong, nonatomic) NSImageView *categoryIcon;
@property (strong, nonatomic) NSTextView *category;

@property (strong, nonatomic) NSImageView *fromAddressIcon;
@property (strong, nonatomic) NSTextView *fromAddress;

//@property (strong, nonatomic) NSImageView *attachedImage;
@property (strong, nonatomic) MKAttachmentView *attachmentView;

@property (assign, nonatomic) BOOL isUpdating;

@property (strong, nonatomic) MKExchangeRate * exchangeRate;

- (MKSell *)sell;

- (void)prepareToDisplay;
- (void)selectFirstResponder;

- (void)setEditable:(BOOL)isEditable;

@end
