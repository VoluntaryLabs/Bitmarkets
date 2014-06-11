//
//  MKSellLockEscrow.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKSellLockEscrow.h"
#import "MKSell.h"
#import "MKRootNode.h"
#import <BitnashKit/BitnashKit.h>

@implementation MKSellLockEscrow

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


- (NSString *)nodeSubtitle
{
    if (!self.runningWallet)
    {
        return @"waiting for wallet..";
    }
    
    if (self.error)
    {
        return self.error;
    }
    
    if (self.confirmLockMsg)
    {
        return @"confirmed";
    }
    
    if (self.isCanceling)
    {
        return @"canceling...";
    }
    
    if (self.isCancelConfirmed)
    {
        return @"cancelled";
    }
    
    if (self.sellerLockMsg)
    {
        return @"awaiting confirm";
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
}

- (void)postLock
{
    BNWallet *wallet = self.runningWallet;
    
    if (!wallet)
    {
        return;
    }
    
    //NSLog(@"remove this return");
    //return YES; // temp
    
    MKSellerPostLockMsg *msg = [[MKSellerPostLockMsg alloc] init];
    [msg copyThreadFrom:self.bidMsg];

    BNTx *buyerEscrowTx = [self.buyerLockMsg.payload asObjectFromJSONObject]; //TODO check errors.  TODO verify tx before signing.
    buyerEscrowTx.wallet = wallet;
    
    wallet.server.logsNextMessage = YES;
    
    [buyerEscrowTx unlockInputs]; //TODO Is this needed since we broadcast it?
    @try
    {
        self.error = nil;
        [buyerEscrowTx sign];
    }
    @catch (NSException *exception)
    {
        self.error = @"escrow sign error";
        return;
    }

    [buyerEscrowTx broadcast];

    [msg sendToBuyer];
    [self addChild:msg];
    [self postParentChainChanged];
}

- (void)postLockIfNeeded
{
    if (self.buyerLockMsg && !self.sellerLockMsg)
    {
        @try
        {
            [self postLock];
        }
        @catch (NSException *exception)
        {
            NSLog(@"postLock failed with exception: %@", exception);
        }
    }
}

- (void)update
{
    [self postLockIfNeeded];
    [self lookForConfirmIfNeeded];
    [self checkCancelConfirmIfNeeded];
    [self updateActions];
}

// confirm methods to extend parent class MKLock

- (MKBidMsg *)bidMsg
{
    return self.sell.bids.acceptedBid.bidMsg;
}

- (BOOL)isComplete
{
    return self.isConfirmed;
}

@end
