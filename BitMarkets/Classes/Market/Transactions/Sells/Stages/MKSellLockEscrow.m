//
//  MKSellLockEscrow.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKSellLockEscrow.h"
#import "MKSell.h"
#import "MKBuyerLockEscrowMsg.h"
#import "MKSellerLockEscrowMsg.h"
#import "MKRootNode.h"
#import <BitnashKit/BitnashKit.h>
#import "MKConfirmLockEscrowMsg.h"

@implementation MKSellLockEscrow

- (id)init
{
    self = [super init];
    return self;
}

- (CGFloat)nodeSuggestedWidth
{
    return 350;
}

- (NSString *)nodeTitle
{
    return @"Lock Escrow";
}

- (NSString *)nodeSubtitle
{
    if (self.sellerLockMsg)
    {
        return @"awaiting blockchain confirm";
    }
    
    if (self.buyerLockMsg)
    {
        return @"got buyer lock";
    }
    
    if (self.sell.bids.acceptedBid)
    {
        return @"awaiting buyer lock";
    }
    
    return nil;
}

- (void)sortChildren
{
    [super sortChildrenWithKey:@"date"];
}

// --------------------

- (MKSell *)sell
{
    return (MKSell *)self.nodeParent;
}

- (BOOL)handleMsg:(MKMsg *)msg
{
    if ([msg isKindOfClass:MKBuyerLockEscrowMsg.class])
    {
        [self addChild:msg];
        [self update];
        return YES;
    }
    
    return NO;
}

- (MKBuyerLockEscrowMsg *)buyerLockMsg
{
    return [self.children firstObjectOfClass:MKBuyerLockEscrowMsg.class];
}

- (MKSellerLockEscrowMsg *)sellerLockMsg
{
    return [self.children firstObjectOfClass:MKSellerLockEscrowMsg.class];
}

- (MKConfirmLockEscrowMsg *)confirmMsg
{
    return [self.children firstObjectOfClass:MKConfirmLockEscrowMsg.class];
}

- (BOOL)sendLock
{
    BNTx *buyerTx = (BNTx *)[self.buyerLockMsg.payload asObjectFromJSONObject]; //TODO handle errors
    
    MKSellerLockEscrowMsg *msg = [[MKSellerLockEscrowMsg alloc] init];
    [msg copyFrom:self.sell.bids.acceptedBid.bidMsg];

    BNWallet *wallet = MKRootNode.sharedMKRootNode.wallet;
    BNTx *tx = [wallet newTx];
    
    [tx configureForEscrowWithValue:self.sell.mkPost.price.longLongValue];
    
    if (tx.error)
    {
        NSLog(@"tx configureForEscrowWithValue failed: %@", tx.error.description);
        if (tx.error.insufficientValue)
        {
            //TODO: prompt user for deposit
            
        }
        else
        {
            [NSException raise:@"tx configureForEscrowWithValue failed" format:nil];
            //TODO: handle unknown tx configureForEscrowWithValue error
        }
    }
    
    tx = [tx mergedWithEscrowTx:buyerTx];
    
    [tx subtractFee];
    [tx sign];
    [tx markInputsAsSpent];
    
    [msg setPayload:[tx asJSONObject]];
    
    [msg sendToBuyer];
    [self addChild:msg];
    [self postSelfChanged];
    [self postParentChanged];
    return YES;
}

- (void)update
{
    if (self.buyerLockMsg && !self.sellerLockMsg)
    {
        [self sendLock];
    }
}

- (BOOL)isConfirmed
{
    return NO;
}

- (void)lookForConfirm
{
    if (!self.confirmMsg)
    {
        BNTx *tx = (BNTx *)[[[self sellerLockMsg] payload] asObjectFromJSONObject];
        
        if ([tx isConfirmed]) //TODO instead check to see if outputs are spent in case tx is mutated
        {
            MKConfirmLockEscrowMsg *msg = [[MKConfirmLockEscrowMsg alloc] init];
            [msg copyFrom:self.sell.bids.acceptedBid.bidMsg];
            [self addChild:msg];
        }
    }
}



@end
