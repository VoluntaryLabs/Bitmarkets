//
//  MKBuyLockEscrow.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKBuyLockEscrow.h"
#import "MKBuyerCancelLockEscrowMsg.h"
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
        return @"canceling...";
    }
    
    if (self.isCancelConfirmed)
    {
        return @"cancelled";
    }
    
    if (self.buyerLockMsg)
    {
        if (self.sellerLockMsg)
        {
            if (self.confirmLockMsg)
            {
                return @"confirmed";
            }
            
            return @"awaiting confirm";
        }
        
        return @"sent - awaiting reply";
    }
    
    if (!self.runningWallet)
    {
        return @"waiting for wallet..";
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
    [self checkCancelConfirmIfNeeded];
    [self updateActions];
}

// send lock

- (void)sendLockToSellerIfNeeded
{
    if (self.buy.bid.wasAccepted && !self.buyerLockMsg)
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

- (BOOL)sendLockToSeller
{
    BNWallet *wallet = self.runningWallet;

    if (!wallet)
    {
        return YES;
    }
    
    
    BNTx *escrowTx = [wallet newTx];
    
    if (self.escrowInputTx)
    {
        [escrowTx configureForEscrowWithInputTx:self.escrowInputTx];
    }
    else
    {
        [escrowTx configureForEscrowWithValue:[NSNumber numberWithLong:2*self.buy.mkPost.priceInSatoshi.longLongValue]];
    }

    
    self.error = nil;
    if (escrowTx.error)
    {
        NSLog(@"tx configureForOutputWithValue failed: %@", escrowTx.error.description);
        if (escrowTx.error.insufficientValue)
        {
            self.error = [NSString stringWithFormat:@"%@BTC Required", escrowTx.error.insufficientValue.satoshiToBtc];
            return NO;
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
        [self.escrowInputTx subtractFee];
        [self.escrowInputTx sign];
        [self.escrowInputTx broadcast];
        return [self sendLockToSeller]; //TODO verify tx in mempool first
    }
    else
    {
        BNTx *sellerEscrowTx = [self.buy.bid.acceptMsg.payload asObjectFromJSONObject]; //TODO handle errors.  TODO verify tx before signing.
        
        escrowTx = [escrowTx mergedWithEscrowTx:sellerEscrowTx];
        [escrowTx subtractFee];
        
        wallet.server.logsNextMessage = YES;
        @try
        {
            self.error = nil;
            [escrowTx sign];
        }
        @catch (NSException *exception)
        {
            self.error = @"escrow sign error";
            return NO;
        }

        [escrowTx lockInputs];
        
        MKBuyerLockEscrowMsg *msg = [[MKBuyerLockEscrowMsg alloc] init];
        [msg copyThreadFrom:self.buy.bidMsg];
        [msg setPayload:[escrowTx asJSONObject]];
        
        [msg sendToSeller];
        [self addChild:msg];
        [self postParentChainChanged];
        
        return YES;
    }
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
