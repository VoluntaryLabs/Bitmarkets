//
//  MKBuy.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/17/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <BitmessageKit/BitMessageKit.h>
#import "MKTransaction.h"
#import "MKPost.h"
#import "MKBuyBid.h"
#import "MKBuyLockEscrow.h"
#import "MKBuyDelivery.h"
#import "MKBuyReleaseEscrow.h"

@interface MKBuy : MKTransaction

@property (strong, nonatomic) MKBuyBid *bid;
@property (strong, nonatomic) MKBuyLockEscrow *lockEscrow;
@property (strong, nonatomic) MKBuyDelivery *delivery;
@property (strong, nonatomic) MKBuyReleaseEscrow *releaseEscrow;

- (MKBidMsg *)bidMsg;
- (BOOL)isCanceled;

@end
