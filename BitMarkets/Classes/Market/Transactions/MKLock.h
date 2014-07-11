//
//  MKLock.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/8/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKEscrow.h"
#import "MKPost.h"

@class MKSell;
@class MKBuy;
@class MKBuyLockEscrowMsg;
@class MKSellLockEscrowMsg;
// messages

#import "MKBidMsg.h"
#import "MKSetupLockMsg.h"
#import "MKConfirmLockEscrowMsg.h"
#import "MKCancelMsg.h"
#import "MKSellLockEscrowMsg.h"


@interface MKLock : MKEscrow

- (BOOL)isConfirmed;

// messages


// messages

- (MKBidMsg *)bidMsg;
- (MKSetupLockMsg *)setupLockMsg;
- (MKBuyLockEscrowMsg *)buyLockEscrowMsg;
- (MKSellLockEscrowMsg *)sellLockEscrowMsg;
- (MKLockMsg *)lockEscrowMsgToConfirm;
- (MKConfirmLockEscrowMsg *)confirmLockEscrowMsg;
- (MKCancelMsg *)cancelMsg;
- (void)postLock:(MKLockMsg *)msg;
- (void)sendMsg:(MKMsg *)msg; //subclasses should override


//state machine
- (void)update;

// lock cancel

- (BOOL)canCancel;

- (BOOL)isCancelling;

- (BOOL)isCancelConfirmed;
- (MKCancelConfirmed *)cancelConfirmedMsg;

- (NSString *)txDescription:(NSString *)description;
- (MKPost *)mkPost;
- (NSNumber *)lockEscrowPriceInSatoshi;

@end
