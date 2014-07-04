//
//  MKBuyLockEscrow.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKBuyLockEscrow.h"
#import "MKBuyerCancelLockEscrowMsg.h"
#import "MKLockEscrowSetupMsg.h"
#import "MKRootNode.h"
#import <BitnashKit/BitnashKit.h>

@implementation MKBuyLockEscrow

- (id)init
{
    self = [super init];
    self.nodeViewClass = NavMirrorView.class;

    NavActionSlot *slot = [self.navMirror newActionSlotWithName:@"cancelEscrow"];
    [slot setVisibleName:@"Cancel Escrow"];
    
    return self;
}

- (void)updateActions
{
    NavActionSlot *slot = [self.navMirror newActionSlotWithName:@"cancelEscrow"];
    [slot setIsActive:self.canCancel];
}

- (BOOL)isConfirmed
{
    return self.confirmLockMsg != nil;
}

- (BOOL)isComplete
{
    return self.isConfirmed;
}

- (BOOL)canCancel
{
    if (self.error)
    {
        return NO;
    }
    
    if (!self.runningWallet)
    {
        return NO;
    }
/*
    if (self.buy.releaseEscrow.isComplete)
    {
        return NO;
    }
*/
    if (self.buyerLockMsg && !self.confirmLockMsg)
    {
        return YES;
    }
    
    return NO;
}

// node

- (NSString *)nodeSubtitle
{
    if (self.error)
    {
        return self.error;
    }
    
    
    if (self.isCanceling && !self.confirmLockMsg)
    {
        return @"canceling bid...";
    }
    
    if (self.isCancelConfirmed)
    {
        return @"bid cancelled";
    }
    
    if (self.buyerLockMsg)
    {
        if (self.sellerLockMsg)
        {
            if (self.confirmLockMsg)
            {
                return @"bid accepted and escrow confirmed";
            }
            
            return @"bid accepted and escrow sent, awaiting confirmation";
        }
        
        return @"bid sent - awaiting reply from seller";
    }
    
    if (!self.runningWallet)
    {
        return @"waiting for wallet...";
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
    if ([msg isKindOfClass:MKSellerPostLockMsg.class])
    {
        [self addChild:msg];
        [self update];
        [self postParentChainChanged];
        [self updateActions];
        return YES;
    }
    
    return NO;
}

// update

- (void)update
{
    [self sendLockToSellerIfNeeded];
    [self lookForConfirmIfNeeded];
    [self updateEscrowSetupIfNeeded];
    [self checkCancelConfirmIfNeeded];
    [self updateActions];
}

// send lock

- (MKLockEscrowSetupMsg *)escrowSetupMsg
{
    return [self.children firstObjectOfClass:MKLockEscrowSetupMsg.class];
}

- (void)updateEscrowSetupIfNeeded
{
    if (self.escrowSetupMsg && !self.buyerLockMsg)
    {
        [self.escrowSetupMsg update];
    }
}

- (void)sendLockToSellerIfNeeded
{
    if (self.buy.bid.wasAccepted && !self.escrowSetupMsg)
    {
        @try
        {
            [self sendLockToSeller];
        }
        @catch (NSException *exception)
        {
            NSLog(@"sendLockToSellerIfNeeded exception %@", exception);
        }

    }
}

- (BOOL)didSendLock
{
    return self.buyerLockMsg != nil;
}

- (NSNumber *)lockEscrowPriceInSatoshi
{
    return [NSNumber numberWithLong:2*self.buy.mkPost.priceInSatoshi.longLongValue];
}

- (void)useEscrowTx:(BNTx *)escrowTx
{
    BNTx *sellerEscrowTx = [self.buy.bid.acceptMsg.payload asObjectFromJSONObject]; //TODO handle errors.  TODO verify tx before signing.
    
    escrowTx = [escrowTx mergedWithEscrowTx:sellerEscrowTx];
    [escrowTx subtractFee];
    
    @try
    {
        self.error = nil;
        [escrowTx sign];
    }
    @catch (NSException *exception)
    {
        self.error = @"escrow sign error";
    }
    
    MKBuyerLockEscrowMsg *msg = [[MKBuyerLockEscrowMsg alloc] init];
    [msg copyThreadFrom:self.buy.bidMsg];
    [msg setPayload:[escrowTx asJSONObject]];
    
    [msg sendToSeller];
    [self addChild:msg];
    [self postParentChainChanged];
}

- (void)sendLockToSeller
{
    MKLockEscrowSetupMsg *escrowSetupMsg = [[MKLockEscrowSetupMsg alloc] init];
    [escrowSetupMsg copyThreadFrom:self.bidMsg];
    escrowSetupMsg.delegate = self;
    [self addChild:escrowSetupMsg];
    [escrowSetupMsg update];
}

- (NSArray *)modelActions
{
    return @[@"cancelEscrow"];
}

- (void)cancelEscrow
{
    BNWallet *wallet = self.runningWallet;
    
    if (!wallet)
    {
        [NSException raise:@"Can't cancelEscrow until wallet is running" format:nil];
    }
    
    BNTx *escrowTx = [[self payloadToConfirm] asObjectFromJSONObject];
    escrowTx.wallet = wallet;
    
    BNTx *cancellationTx = escrowTx.cancellationTx;
    [cancellationTx unlockInputs];
    [cancellationTx sign];
    [cancellationTx broadcast];
    
    MKBuyerCancelLockEscrowMsg *msg = [[MKBuyerCancelLockEscrowMsg alloc] init];
    msg.payload = [cancellationTx asJSONObject];
    [self addChild:msg];
    [self postParentChainChanged];
}

// confirm methods to extend parent class MKLock

- (MKBidMsg *)bidMsg
{
    return self.buy.bid.bidMsg;
}

@end
