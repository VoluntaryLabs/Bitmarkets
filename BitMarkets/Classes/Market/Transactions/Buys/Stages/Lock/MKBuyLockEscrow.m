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
    
    if (self.isConfirmed)
    {
        return @"Escrow confirmed.";
    }
    
    if (self.isCancelling)
    {
        return @"Cancelling escrow ...";
    }
    
    if (self.isCancelConfirmed)
    {
        return @"Escrow cancelled.";
    }
    
    if (self.buyLockEscrowMsg)
    {
        return @"Bid accepted and escrow sent. Awaiting confirmation...";
    }
    
    if (self.sellLockEscrowMsg)
    {
        return @"Received seller escrow. Completing and returning.";
    }
    
    if (self.setupLockMsg)
    {
        if (self.setupLockMsg.isTxConfirmed)
        {
            return @"Exact change ready for escrow lock. Awaiting seller escrow...";
        }
        
        return @"Preparing exact change for escrow lock...";
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
        self.buyLockEscrowMsg.tx.txType = @"Lock Escrow";
        self.buyLockEscrowMsg.tx.description = self.txDescription;
    }
}

- (void)broadcastLockIfNeeded
{
    /// need to override but buyer doesn't broadcast
}

- (BOOL)isBuyer
{
    return YES;
}


@end
