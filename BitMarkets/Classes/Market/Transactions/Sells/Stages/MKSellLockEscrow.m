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

//messages

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
    BNWallet *wallet = MKRootNode.sharedMKRootNode.wallet;
    
    if (!wallet.isRunning)
    {
        return YES; // this effectively just reports that the msg was valid
    }
    
    //NSLog(@"remove this return");
    //return YES; // temp
    
    BNTx *buyerTx = (BNTx *)[self.buyerLockMsg.payload asObjectFromJSONObject]; //TODO handle errors
    BNTx *tx = [wallet newTx];
    
    long long priceInSatoshi = self.sell.mkPost.priceInSatoshi.longLongValue;
    [tx configureForEscrowWithValue:priceInSatoshi];
    
    if (tx.error)
    {
        NSLog(@"tx configureForEscrowWithValue failed: %@", tx.error.description);
        if (tx.error.insufficientValue)
        {
            //TODO: prompt user for deposit
            NSLog(@"need to deposit funds");
        }
        else
        {
            [NSException raise:@"tx configureForEscrowWithValue failed" format:nil];
            //TODO: handle unknown tx configureForEscrowWithValue error
        }
        return YES;
    }
    
    tx = [tx mergedWithEscrowTx:buyerTx];
    
    [tx subtractFee];
    [tx sign];
    [tx markInputsAsSpent];
    
    if ([tx asJSONObject] == nil)
    {
        NSLog(@"ERROR: MKSellerLockEscrowMsg payload --------------");
        return NO;
    }
    
    
    MKSellerLockEscrowMsg *msg = [[MKSellerLockEscrowMsg alloc] init];
    [msg copyFrom:self.bidMsg];
    [msg setPayload:[tx asJSONObject]];
    [msg sendToBuyer];
    [self addChild:msg];
    [self postParentChainChanged];
    return YES;
}

- (void)sendLockIfNeeded
{
    if (self.buyerLockMsg && !self.sellerLockMsg)
    {
        @try
        {
            [self sendLock];
        }
        @catch (NSException *exception)
        {
            NSLog(@"sendLock failed with exception: %@", exception);
        }
    }
}

- (void)update
{
    [self sendLockIfNeeded];
    [self lookForConfirmIfNeeded];
}

// confirm methods to extend parent class MKLock

- (MKBidMsg *)bidMsg
{
    return self.sell.bids.acceptedBid.bidMsg;
}

// confirm

- (NSDictionary *)payloadToConfirm
{
    return self.buyerLockMsg.payload;
}

- (BOOL)shouldLookForConfirm; // subclasses should override
{
    return (self.buyerLockMsg && !self.confirmMsg);
}

- (BOOL)isComplete
{
    return self.isConfirmed;
}


@end
