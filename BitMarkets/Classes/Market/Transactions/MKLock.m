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
#import "MKBuyLockEscrowMsg.h"
#import "MKSellLockEscrowMsg.h"
#import <BitnashKit/BitnashKit.h>

@implementation MKLock

- (id)init
{
    self = [super init];
    
    self.nodeViewClass = NavMirrorView.class;
    
    NavActionSlot *slot = [self.navMirror newActionSlotWithName:@"cancelEscrow"];
    [slot setVisibleName:@"Cancel Escrow"];
    [slot setIsActive:NO];
    [slot setVerifyMessage:@"It can take a while for the other party to complete the escrow lock. Are you sure you want to cancel this transaction?"];
    
    return self;
}

- (NSString *)nodeNote
{
    if (self.error || self.isCancelConfirmed)
    {
        return @"✗";
    }
    
    if (self.isConfirmed)
    {
        return @"✓";
    }
    
    if (self.isActive)
    {
        return @"●";
    }
    
    return nil;
}

- (BOOL)isActive
{
    return !self.isComplete && (self.setupLockMsg != nil);
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

- (void)updateActions
{
    NavActionSlot *slot = [self.navMirror newActionSlotWithName:@"cancelEscrow"];
    [slot setIsActive:self.runningWallet != nil && self.canCancel];
}

//MKStage

- (BOOL)isComplete
{
    return self.isConfirmed; //|| self.isCancelConfirmed;
}

// messages

- (void)sendMsg:(MKMsg *)msg
{
    [NSException raise:@"Subclasses should override" format:nil];
}

- (MKBidMsg *)bidMsg
{
    [NSException raise:@"Subclasses should override" format:nil];
    return nil;
}

//MKLockEscrow delegation

- (MKPost *)mkPost
{
    return nil;
}

- (NSNumber *)lockEscrowPriceInSatoshi //implement in subclass
{
    return nil;
}

//state machine

//both: setup
//seller: configure & send
//buyer: merge, sign & send
//seller: sign & broadcast
//both: confirm
- (void)update
{
    if (self.runningWallet && !self.isComplete)
    {
        [self setupLockIfNeeded];
        [self postLockIfNeeded];
        [self broadcastLockIfNeeded];
        [self confirmLockIfNeeded];
        [self confirmCancellationIfNeeded];
        [self unlockInputsIfNeeded];
        [self updateActions];
    }
}

// --- setup lock ---

- (MKSetupLockMsg *)setupLockMsg
{
    return [self firstChildWithKindOfClass:[MKSetupLockMsg class]];
}

- (void)setupLockIfNeeded
{
    if (self.bidMsg && (!self.setupLockMsg || !self.setupLockMsg.tx))
    {
        MKSetupLockMsg *setupLockMsg = self.setupLockMsg;
        
        if (!self.setupLockMsg)
        {
            setupLockMsg = [MKSetupLockMsg new];
            [self addChild:setupLockMsg];
            [self postParentChainChanged];
        }
        
        @try
        {
            [setupLockMsg configureAndBroadcastTx];
        }
        @catch (NSException *exception)
        {
            [self setError:exception.name];
        }

        setupLockMsg.tx.txType = @"Setup Escrow";
        setupLockMsg.tx.description = self.txDescription;
    }
}

// --- lock ---

- (MKBuyLockEscrowMsg *)buyLockEscrowMsg
{
    return [self firstChildWithKindOfClass:[MKBuyLockEscrowMsg class]];
}

- (MKSellLockEscrowMsg *)sellLockEscrowMsg
{
    return [self firstChildWithKindOfClass:[MKSellLockEscrowMsg class]];
}

- (MKLockMsg *)lockEscrowMsgToConfirm
{
    return self.buyLockEscrowMsg;
}

- (MKConfirmLockEscrowMsg *)confirmLockEscrowMsg
{
    return [self.children firstObjectOfClass:[MKConfirmLockEscrowMsg class]];
}

- (void)postLockIfNeeded
{
    [NSException raise:@"Subclasses should override" format:nil];
}

- (void)postLock:(MKLockMsg *)msg
{
    [self addChild:msg]; //so nodeParent is set.
    [msg configureTx];
    [msg copyThreadFrom:self.bidMsg];
    msg.payload = msg.tx.asJSONObject;
    [self sendMsg:msg];
    [self postParentChainChanged];

}


- (void)broadcastLockIfNeeded
{
    [NSException raise:@"Subclasses should override" format:nil];
}

- (BOOL)isConfirming
{
    return self.lockEscrowMsgToConfirm.tx.wasBroadcast;
}

- (void)confirmLockIfNeeded
{
    if (!self.isConfirmed &&
        !self.cancelMsg &&
        self.lockEscrowMsgToConfirm &&
        self.lockEscrowMsgToConfirm.isTxConfirmed)
    {
        MKConfirmLockEscrowMsg *msg = [[MKConfirmLockEscrowMsg alloc] init];
        [self addChild:msg];
        [self postParentChainChanged];
    }
}

- (BOOL)isConfirmed
{
    return self.lockEscrowMsgToConfirm.isTxConfirmed;
}

// --- lock cancel ---

- (void)cancelEscrow
{
    BNWallet *wallet = self.runningWallet;
    
    if (!wallet)
    {
        [NSException raise:@"Can't cancelEscrow until wallet is running" format:nil];
    }
    
    MKCancelMsg *msg = [[MKCancelMsg alloc] init];
    [self addChild:msg];
    [msg configureTx];
    [msg broadcast];
    msg.tx.txType = @"Cancel Escrow";
    msg.tx.description = self.txDescription;
    [self postParentChainChanged];

}

- (BOOL)canCancel
{
    if (!self.runningWallet ||
        self.isCancelling ||
        self.isCancelConfirmed ||
        self.isConfirming ||
        self.isComplete
    )
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)isCancelling
{
    return self.cancelMsg != nil && !self.isCancelConfirmed;
}

- (MKCancelMsg *)cancelMsg
{
    return [self.children firstObjectOfClass:MKCancelMsg.class];
}

- (BOOL)isCancelConfirmed
{
    BOOL lockIsCancelled = NO;
    
    if (self.lockEscrowMsgToConfirm.tx)
    {
        [self.lockEscrowMsgToConfirm.tx refresh];
        lockIsCancelled = self.lockEscrowMsgToConfirm.tx.isCancelled;
    }
    
    BOOL cancelConfirmedMsgExists = self.cancelConfirmedMsg != nil;
    BOOL cancelMsgTxIsNil = (self.cancelMsg && (self.cancelMsg.tx == nil));
    
    return lockIsCancelled || cancelConfirmedMsgExists || cancelMsgTxIsNil;
}

/*
- (BOOL)isCancelConfirmed
{
    BOOL lockIsCancelled = self.lockEscrowMsgToConfirm.tx && self.lockEscrowMsgToConfirm.tx.isCancelled;
    BOOL cancelConfirmedMsgExists = self.cancelConfirmedMsg != nil;
    BOOL cancelMsgTxIsNil = (self.cancelMsg && (self.cancelMsg.tx == nil));
    
    return lockIsCancelled || cancelConfirmedMsgExists || cancelMsgTxIsNil;
}
 */

- (MKCancelConfirmed *)cancelConfirmedMsg
{
    return [self.children firstObjectOfClass:[MKCancelConfirmed class]];
}

- (void)confirmCancellation
{
    MKCancelConfirmed *msg = [[MKCancelConfirmed alloc] init];
    [self addChild:msg];
    [self postParentChainChanged];
}

- (void)confirmCancellationIfNeeded
{
    if (self.cancelMsg && !self.cancelConfirmedMsg && self.cancelMsg.isTxConfirmed)
    {
        [self confirmCancellation];
    }
}

- (void)unlockInputsIfNeeded
{
    if (self.isCancelConfirmed && self.lockEscrowMsgToConfirm.tx && !self.cancelConfirmedMsg)
    {
        [self confirmCancellation];
        [self.lockEscrowMsgToConfirm.tx unlockInputs];
    }
}

- (BOOL)isBuyer
{
    [NSException raise:@"Subclasses should override" format:nil];
    return NO;
}

- (NSString *)txDescription
{
    return self.isBuyer ? self.buy.description : self.sell.description;
}

- (BOOL)canDelete
{
    if (self.setupLockMsg)
    {
        if (self.isComplete || self.isCancelConfirmed)
        {
            return YES;
        }

        return NO;
    }
    
    return YES;
}

@end
