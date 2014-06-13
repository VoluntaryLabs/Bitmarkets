//
//  MKLock.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/8/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKLock.h"
#import "MKBuy.h"
#import "MKSell.h"
#import "MKRootNode.h"
#import <BitnashKit/BitnashKit.h>

@implementation MKLock

- (NSString *)nodeNote
{
    if (self.error || self.isCancelConfirmed)
    {
        return @"✗";
    }
    
    if (self.isActive)
    {
        return @"●";
    }
    
    if (self.confirmLockMsg)
    {
        return @"✓";
    }
    
    return nil;
}

- (BOOL)isActive
{
    return self.buyerLockMsg && !self.confirmLockMsg;
}

// node

- (CGFloat)nodeSuggestedWidth
{
    return 350;
}

- (void)sortChildren
{
    [super sortChildrenWithKey:@"date"];
}

- (NSString *)nodeTitle
{
    return @"Lock Escrow";
}

// confirm

- (BOOL)isConfirmed
{
    return self.confirmLockMsg != nil;
}


- (NSDictionary *)payloadToConfirm
{
    return self.buyerLockMsg.payload;
}

- (BNTx *)tx
{
    BNWallet *wallet = self.runningWallet;
    if (!wallet)
    {
        return nil;
    }
    
    BNTx *tx = (BNTx *)[self.payloadToConfirm asObjectFromJSONObject];
    tx.wallet = wallet;
    [tx refresh];
    return tx;
}

- (BOOL)checkForConfirm
{
    if ([self.tx isConfirmed]) // TODO instead check to see if outputs are spent in case tx is mutated
    {
        return YES;
    }

    return NO;
}

- (MKBidMsg *)bidMsg
{
    [NSException raise:@"subclasses should override" format:nil];
    return nil;
}

- (void)lookForConfirmIfNeeded
{
    if (self.shouldLookForConfirm)
    {
        if (self.checkForConfirm)
        {
            MKConfirmLockEscrowMsg *msg = [[MKConfirmLockEscrowMsg alloc] init];
            //[msg copyThreadFrom:self.bidMsg];
            [self addChild:msg];
        }
    }
}

- (BOOL)shouldLookForConfirm // subclasses should override
{
    return (self.buyerLockMsg && !self.confirmLockMsg);
}

// messages

- (MKSellerPostLockMsg *)sellerLockMsg
{
    return [self.children firstObjectOfClass:MKSellerPostLockMsg.class];
}

- (MKBuyerLockEscrowMsg *)buyerLockMsg
{
    return [self.children firstObjectOfClass:MKBuyerLockEscrowMsg.class];
}

- (MKConfirmLockEscrowMsg *)confirmLockMsg
{
    return [self.children firstObjectOfClass:MKConfirmLockEscrowMsg.class];
}

// lock cancel

- (BOOL)canCancel
{
    if (!self.runningWallet)
    {
        return NO;
    }
    
    if (self.isCanceling || self.isCancelConfirmed)
    {
        return NO;
    }
    
    if (self.sellerLockMsg && !self.confirmLockMsg)
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)isCanceling
{
    return self.cancelMsg != nil && !self.isCancelConfirmed;
}

- (MKCancelMsg *)cancelMsg
{
    return [self.children firstObjectOfClass:MKCancelMsg.class];
}

// cancel confirmed

- (void)checkCancelConfirmIfNeeded
{
    if (!self.cancelConfirmedMsg && !self.isConfirmed)
    {
        if([self.tx isCancelled])
        {
            MKCancelConfirmed *msg = [[MKCancelConfirmed alloc] init];
            [self addChild:msg];
            [self postParentChainChanged];
        }
    }
}

- (BOOL)isCancelConfirmed
{
    return self.cancelConfirmedMsg != nil;
}

- (MKCancelConfirmed *)cancelConfirmedMsg
{
    return [self.children firstObjectOfClass:MKCancelConfirmed.class];
}

@end
