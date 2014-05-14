//
//  MKBuyLockEscrow.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKBuyLockEscrow.h"
#import "MKRootNode.h"
#import <BitnashKit/BitnashKit.h>

@implementation MKBuyLockEscrow

/*
- (id)init
{
    self = [super init];
    return self;
}
*/

// node

- (NSString *)nodeSubtitle
{
    if (self.sellerLockMsg)
    {
        return @"awaiting blockchain confirm";
    }
    
    if (self.buyerLockMsg)
    {
        return @"sent - awaiting reply";
    }
    
    return nil;
}

- (MKBuy *)buy
{
    MKBuy *buy = (MKBuy *)[self firstInParentChainOfClass:MKBuy.class];
    assert(buy != nil);
    return buy;
}

// ---------------------

- (BOOL)handleMsg:(MKMsg *)msg
{
    if ([msg isKindOfClass:MKSellerLockEscrowMsg.class])
    {
        [self addChild:msg];
        [self update];
        return YES;
    }
    
    return NO;
}

// update

- (void)update
{
    [self sendLockToSellerIfNeeded];
    [self postLockToBlockchainIdNeeded];
    [self lookForConfirmIfNeeded];
}

// send lock

- (void)sendLockToSellerIfNeeded
{
    if (self.buy.bid.wasAccepted && !self.buyerLockMsg)
    {
        [self sendLockToSeller];
    }
}

- (BOOL)didSendLock
{
    return self.buyerLockMsg != nil;
}

- (BOOL)sendLockToSeller
{
    MKBuyerLockEscrowMsg *msg = [[MKBuyerLockEscrowMsg alloc] init];
    [msg copyFrom:self.buy.bid.bidMsg];
    
    BNWallet *wallet = MKRootNode.sharedMKRootNode.wallet;
    
    BNTx *escrowTx = [wallet newTx];
    
    if (self.escrowInputTx)
    {
        [escrowTx configureForEscrowWithInputTx:self.escrowInputTx];
    }
    else
    {
        [escrowTx configureForEscrowWithValue:[NSNumber numberWithLong:2*self.buy.mkPost.priceInSatoshi.longLongValue]];
    }

    
    if (escrowTx.error)
    {
        NSLog(@"tx configureForOutputWithValue failed: %@", escrowTx.error.description);
        if (escrowTx.error.insufficientValue)
        {
            //TODO: prompt user for deposit
            
        }
        else
        {
            [NSException raise:@"tx configureForOutputWithValue failed" format:nil];
            //TODO: handle unknown tx configureForEscrowWithValue error
        }
        return NO;
    }
    
    if ([escrowTx changeValue].longLongValue > 10000)
    {
        //create an output that won't lock up more than needed
        self.escrowInputTx = [wallet newTx];
        
        [self.escrowInputTx configureForOutputWithValue:[NSNumber numberWithLongLong:
                                         [(BNTxOut *)[escrowTx.outputs firstObject] value].longLongValue + [escrowTx fee].longLongValue]];
        [self.escrowInputTx sign];
        [self.escrowInputTx broadcast];
        return [self sendLockToSeller]; //TODO verify tx in mempool first
    }
    else
    {
        BNTx *sellerEscrowTx = [self.buy.bid.acceptMsg.payload asObjectFromJSONObject]; //TODO handle errors.  TODO verify tx before signing.
        
        escrowTx = [escrowTx mergedWithEscrowTx:sellerEscrowTx];
        [escrowTx subtractFee];
        [escrowTx sign];
        [escrowTx markInputsAsSpent];
        
        [msg setPayload:[escrowTx asJSONObject]];
        
        [msg sendToSeller];
        [self addChild:msg];
        
        return YES;
    }
}

// post lock

- (void)postLockToBlockchainIdNeeded
{
    if (self.sellerLockMsg && !self.buyerLockMsg)
    {
        [self postLockToBlockchain];
    }
}

- (BOOL)postLockToBlockchain
{
    NSDictionary *payload = self.sellerLockMsg.payload;
    BNTx *tx = (BNTx *)[payload asObjectFromJSONObject];
    tx.wallet = MKRootNode.sharedMKRootNode.wallet;
    
    MKBuyerLockEscrowMsg *msg = [[MKBuyerLockEscrowMsg alloc] init];
    [msg copyFrom:self.buy.bid.bidMsg];
    
    [tx sign]; //TODO verify expected outputs first.
    [tx broadcast];
    
    [self addChild:msg];
    
    return NO;
}

// confirm methods to extend parent class MKLock

- (MKBidMsg *)bidMsg
{
    return self.buy.bid.bidMsg;
}

- (NSDictionary *)payloadToConfirm
{
    return self.buyerLockMsg.payload;
}

- (BOOL)shouldLookForConfirm; // subclasses should override
{
    return (self.buyerLockMsg && !self.confirmLockMsg);
}


@end
