//
//  MKLock.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/8/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKGroup.h"

@class MKSell;
@class MKBuy;

// messages

#import "MKBidMsg.h"
#import "MKBuyerLockEscrowMsg.h"
#import "MKSellerLockEscrowMsg.h"
#import "MKConfirmLockEscrowMsg.h"


@interface MKLock : MKGroup

- (MKSell *)sell;
- (MKBuy *)buy;

// conifrm

- (BOOL)isConfirmed;
- (void)lookForConfirmIfNeeded;
- (NSDictionary *)payloadToConfirm; // subclasses should override
- (BOOL)shouldLookForConfirm; // subclasses should override

//messages

- (MKBuyerLockEscrowMsg *)buyerLockMsg;
- (MKSellerLockEscrowMsg *)sellerLockMsg;
- (MKConfirmLockEscrowMsg *)confirmLockMsg;

@end
