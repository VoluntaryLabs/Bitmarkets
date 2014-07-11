//
//  MKBuyLockEscrow.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKBuyLockEscrow.h"
#import "MKBuyLockEscrowMsg.h"
#import "MKRootNode.h"
#import <BitnashKit/BitnashKit.h>

@implementation MKBuyLockEscrow

//node

- (NSString *)nodeSubtitle
{
    if (self.error)
    {
        return self.error;
    }
    
    if (!self.runningWallet)
    {
        return @"Waiting for wallet ...";
    }
    
    if (self.isCancelling)
    {
        return @"Cancelling escrow ...";
    }
    
    if (self.isCancelConfirmed)
    {
        return @"Escrow cancelled.";
    }
    
    if (self.isConfirmed)
    {
        return @"Escrow confirmed.";
    }
    
    if (self.sellLockEscrowMsg)
    {
        return @"Received seller escrow.  Sending escrow to seller.";
    }
    
    if (self.buyLockEscrowMsg)
    {
        return @"Bid accepted and escrow sent.  Awaiting confirmation.";
    }
    
    if (self.setupLockMsg)
    {
        return @"Awaiting seller escrow ...";
    }
    
    return nil;
}


- (MKBuy *)buy
{
    MKBuy *buy = (MKBuy *)[self firstInParentChainOfClass:MKBuy.class];
    assert(buy != nil);
    return buy;
}

//MKLockEscrowMsg delegation

- (MKPost *)mkPost
{
    return self.buy.mkPost;
}

- (NSNumber *)lockEscrowPriceInSatoshi
{
    return [NSNumber numberWithLong:2*self.mkPost.priceInSatoshi.longLongValue];
}

//messages

- (void)sendMsg:(MKMsg *)msg
{
    [msg sendToSeller];
}

- (MKBidMsg *)bidMsg
{
    return self.buy.bid.bidMsg;
}

- (BOOL)handleMsg:(MKMsg *)msg
{
    if ([msg isKindOfClass:[MKSellLockEscrowMsg class]])
    {
        [self addChild:msg];
        return YES;
    }
    
    return NO;
}

//state machine

- (void)postLockIfNeeded
{
    if (self.setupLockMsg &&
        self.sellLockEscrowMsg &&
        !self.buyLockEscrowMsg &&
        self.setupLockMsg.isTxConfirmed)
    {
        [self postLock:[[MKBuyLockEscrowMsg alloc] init]];
        self.buyLockEscrowMsg.tx.description = [self txDescription:@"Lock Escrow"];
    }
}

- (void)broadcastLockIfNeeded
{
    
}

@end
