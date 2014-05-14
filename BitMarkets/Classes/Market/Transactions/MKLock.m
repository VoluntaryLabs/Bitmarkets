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
    if (self.isConfirmed)
    {
        return @"✓";
    }
    
    return nil;
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

// confirm

- (NSDictionary *)payloadToConfirm
{
    [NSException raise:@"subclasses should override" format:nil];
    return nil;
}

- (BOOL)checkForConfirm
{
    if (!MKRootNode.sharedMKRootNode.wallet.isRunning)
    {
        return NO;
    }
    
    BNTx *tx = (BNTx *)[self.payloadToConfirm asObjectFromJSONObject];
    tx.wallet = MKRootNode.sharedMKRootNode.wallet;
    
    if ([tx isConfirmed]) //TODO instead check to see if outputs are spent in case tx is mutated
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
            [msg copyFrom:self.bidMsg];
            [self addChild:msg];
        }
    }
}

- (BOOL)shouldLookForConfirm
{
    [NSException raise:@"subclasses should override" format:nil];
    //return (self.buyerLockMsg && !self.confirmLockMsg);
    return NO;
}

//messages

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

@end
