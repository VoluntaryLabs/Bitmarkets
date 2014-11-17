//
//  MKSellLockEscrow.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKSellLockEscrow.h"
#import "MKBuyLockEscrowMsg.h"
#import "MKSell.h"
#import "MKRootNode.h"
#import <BitnashKit/BitnashKit.h>

@implementation MKSellLockEscrow

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
    
    if (self.confirmLockEscrowMsg)
    {
        return @"Escrow confirmed.";
    }
    
    if (self.isCancelConfirmed)
    {
        return @"Escrow cancelled.";
    }
    
    if (self.isCancelling)
    {
        return @"Cancelling escrow ...";
    }
    
    if (self.buyLockEscrowMsg)
    {
        return @"Buyer escrow received. Awaiting confirmation.";
    }
    
    if (self.sellLockEscrowMsg || self.setupLockMsg)
    {
        return @"Awaiting buyer escrow ...";
    }

    
    return nil;
}

//MKLockEscrowMsg delegation

- (MKPost *)mkPost
{
    return self.sell.mkPost;
}

- (NSNumber *)lockEscrowPriceInSatoshi
{
    return [NSNumber numberWithLongLong:self.mkPost.priceInSatoshi.longLongValue];
}

//messages

- (void)sendMsg:(MKMsg *)msg
{
    [msg sendToBuyer];
}

- (BOOL)handleMsg:(MKMsg *)msg
{
    if ([msg isKindOfClass:[MKBuyLockEscrowMsg class]])
    {
        [self addChild:msg];
        [self update];
        [self postParentChainChanged];
        return YES;
    }
    
    return NO;
}

- (MKSell *)sell
{
    return (MKSell *)self.nodeParent;
}

- (MKBidMsg *)bidMsg
{
    return self.sell.bids.acceptedBid.bidMsg;
}

- (void)postLockIfNeeded
{
    if (self.setupLockMsg && !self.sellLockEscrowMsg && self.setupLockMsg.isTxConfirmed)
    {
        [self postLock:[[MKSellLockEscrowMsg alloc] init]];
    }
}

- (void)broadcastLockIfNeeded
{
    if (self.buyLockEscrowMsg && !self.buyLockEscrowMsg.tx.wasBroadcast)
    {
        [self.buyLockEscrowMsg broadcast];
        self.buyLockEscrowMsg.tx.txType = @"Lock Escrow";
        self.buyLockEscrowMsg.tx.description = self.txDescription;
    }
}

- (BOOL)isBuyer
{
    return NO;
}

@end
