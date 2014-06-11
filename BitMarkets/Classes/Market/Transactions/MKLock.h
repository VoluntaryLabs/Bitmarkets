//
//  MKLock.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/8/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKEscrow.h"

@class MKSell;
@class MKBuy;

// messages

#import "MKBidMsg.h"
#import "MKBuyerLockEscrowMsg.h"
#import "MKSellerPostLockMsg.h"
#import "MKBuyerLockEscrowMsg.h"
#import "MKConfirmLockEscrowMsg.h"


@interface MKLock : MKEscrow

// conifrm

- (BOOL)isConfirmed;
- (void)lookForConfirmIfNeeded;
- (NSDictionary *)payloadToConfirm; // subclasses should override
- (BOOL)shouldLookForConfirm; // subclasses should override

// messages

- (MKBuyerLockEscrowMsg *)buyerLockMsg;
- (MKSellerPostLockMsg *)sellerLockMsg;
- (MKConfirmLockEscrowMsg *)confirmLockMsg;

// lock cancel

- (BOOL)canCancel;

- (BOOL)isCanceling;
- (void)checkCancelConfirmIfNeeded;

- (MKCancelMsg *)cancelMsg;

- (BOOL)isCancelConfirmed;
- (MKCancelConfirmed *)cancelConfirmedMsg;

@end
