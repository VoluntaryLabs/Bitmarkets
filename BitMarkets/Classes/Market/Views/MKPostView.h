//
//  BMAddressedView.h
//  Bitmessage
//
//  Created by Steve Dekorte on 2/21/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <NavKit/NavKit.h>
#import "MKSell.h"
#import "MKExchangeRate.h"
#import "MKAttachmentView.h"

@interface MKPostView : NSView <NSTextViewDelegate>

@property (assign, nonatomic) NavView *navView;
@property (assign, nonatomic) NavNode *node;

@property (strong, nonatomic) NavAdvTextView *title;
//@property (strong, nonatomic) IBOutlet NSTextView *quantity;
@property (strong, nonatomic) NavAdvTextView *price;
@property (strong, nonatomic) NavRoundButtonView *postOrBuyButton;

@property (strong, nonatomic) NavColoredView *separator;

@property (strong, nonatomic) NavAdvTextView *postDescription;

@property (strong, nonatomic) NSImageView *regionIcon;
@property (strong, nonatomic) NSTextView *region;

@property (strong, nonatomic) NSImageView *categoryIcon;
@property (strong, nonatomic) NSTextView *category;

@property (strong, nonatomic) NSImageView *fromAddressIcon;
@property (strong, nonatomic) NSTextView *fromAddress;

@property (strong, nonatomic) MKAttachmentView *attachmentView;

@property (assign, nonatomic) BOOL isUpdating;
@property (assign, nonatomic) BOOL editable;

@property (strong, nonatomic) MKExchangeRate * exchangeRate;

+ (CGFloat)leftMargin;

- (MKSell *)sell;

- (void)selectFirstResponder;

- (void)setEditable:(BOOL)isEditable;

@end
