//
//  MKBuyReleaseEscrow.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKBuyReleaseEscrow.h"
#import "MKBuy.h"
#import "MKRootNode.h"
#import "MKBuyPostRefundMsg.h"
#import "MKBuyPostPaymentMsg.h"

@implementation MKBuyReleaseEscrow

- (id)init
{
    self = [super init];
    self.nodeViewClass = NavMirrorView.class;
    
    {
        NavActionSlot *slot = [self.navMirror newActionSlotWithName:@"requestRefund"];
        [slot setVisibleName:@"Request Refund"];
    }
    
    {
        NavActionSlot *slot = [self.navMirror newActionSlotWithName:@"makePayment"];
        [slot setVisibleName:@"Make Payment"];
    }

    return self;
}

- (CGFloat)nodeSuggestedWidth
{
    return 300.0;
}

- (NSArray *)modelActions
{
    return @[];
//    return @[@"requestRefund", @"makePayment"];
}


- (NSString *)nodeSubtitle
{
    if (!self.runningWallet)
    {
        return @"waiting for wallet..";
    }
    
    if (self.buyRequestRefundMsg)
    {
        if(!self.sellAcceptRefundRequestMsg)
        {
            return @"awaiting refund response";
        }
        
        if (!self.confirmRefundMsg)
        {
            return @"awaiting refund confirm";
        }
        
        return @"refund confirmed";
    }
    
    if (self.buyPaymentMsg)
    {
        if(!self.sellAcceptPaymentMsg)
        {
            return @"awaiting payment response";
        }
        
        if (!self.confirmPaymentMsg)
        {
            return @"awaiting payment confirm";
        }
        
        return @"payment confirmed";
    }
    
    return nil;
}

- (BOOL)isActive
{
    /*
    if (!self.runningWallet)
    {
        return NO;
    }
*/
    return self.buy.lockEscrow.isConfirmed && !self.isComplete;
//    return (self.buyPaymentMsg || self.buyRequestRefundMsg) && !self.isComplete;
}

- (BOOL)isComplete
{
    return (self.confirmPaymentMsg || self.confirmRefundMsg);
}

- (NSString *)nodeNote
{
    if (self.isComplete)
    {
        return @"✓";
    }
    
    if (self.isActive)
    {
        return @"●";
    }
    
    /*
    if (self.wasRejected)
    {
        return @"✗";
    }
    */
    
    return nil;
}

// update

- (BOOL)handleMsg:(MKMsg *)msg
{
    if ([msg isKindOfClass:MKSellAcceptPaymentMsg.class] ||
        [msg isKindOfClass:MKSellAcceptRefundRequestMsg.class] ||
        [msg isKindOfClass:MKSellRejectRefundRequestMsg.class])
    {
        [self addChild:msg];
        [self update];
        [self postParentChainChanged];
        return YES;
    }
    
    return NO;
}


- (void)update
{
    if (self.sellAcceptPaymentMsg && !self.buyPostPaymentMsg)
    {
        [self signAndPostAcceptToBlockChain];
    }
    
    if (self.sellAcceptRefundRequestMsg && !self.buyPostRefundMsg)
    {
        [self signAndPostRefundToBlockChain];
    }
    
    [self lookForConfirmsIfNeeded];
    
    [self updateActions];
}

- (void)updateActions
{
    BOOL isActive = self.isActive && (self.runningWallet != nil);

    [[self.navMirror actionSlotNamed:@"requestRefund"] setIsActive:isActive && !self.buyRequestRefundMsg];
    [[self.navMirror actionSlotNamed:@"makePayment"]   setIsActive:isActive && !self.buyPaymentMsg];
}

// initiate payemnt

- (void)makePayment // user initiated
{
    //self.buy.lockEscrow.pos
    
    BNWallet *wallet = self.runningWallet;
    
    if (!wallet)
    {
        return;
    }
    
    BNTx *escrowTx = [self.buy.lockEscrow.payloadToConfirm asObjectFromJSONObject]; //TODO handle errors
    
    BNTx *releaseTx = [[BNTx alloc] init];
    releaseTx.wallet = wallet;
    [releaseTx configureForReleaseWithInputTx:escrowTx];
    [releaseTx addPayToAddressOutputWithValue:[NSNumber numberWithLongLong:escrowTx.firstOutput.value.longLongValue/3]];
    
    MKBuyPaymentMsg *msg = [[MKBuyPaymentMsg alloc] init];
    [msg setPayload:[releaseTx asJSONObject]];
    [msg copyThreadFrom:self.buy.bidMsg];
    [msg sendToSeller];
    
    [self addChild:msg];
    [self update];
}

// initiate refund

- (void)requestRefund // user initiated
{
    BNWallet *wallet = MKRootNode.sharedMKRootNode.wallet;
    
    if (!wallet.isRunning)
    {
        return;
    }
    
    BNTx *escrowTx = [self.buy.lockEscrow.payloadToConfirm asObjectFromJSONObject]; //TODO handle errors
    
    BNTx *refundTx = [[BNTx alloc] init];
    refundTx.wallet = wallet;
    [refundTx configureForReleaseWithInputTx:escrowTx];
    [refundTx addPayToAddressOutputWithValue:[NSNumber numberWithLongLong:2*escrowTx.firstOutput.value.longLongValue/3]];
    
    MKBuyRefundRequestMsg *msg = [[MKBuyRefundRequestMsg alloc] init];
    [msg copyThreadFrom:self.buy.bidMsg];
    [msg setPayload:refundTx.asJSONObject];
    [msg sendToSeller];
    
    [self addChild:msg];
    [self update];
}

// post payment

- (MKBuyPostPaymentMsg *)buyPostPaymentMsg
{
    return [self.children firstObjectOfClass:MKBuyPostPaymentMsg.class];
}

- (void)signAndPostAcceptToBlockChain
{
    BNWallet *wallet = [MKRootNode sharedMKRootNode].wallet;
    
    if (!wallet.isRunning)
    {
        return;
    }
    
    if (!self.buyPostPaymentMsg)
    {
        BNTx *releaseTx = self.sellAcceptPaymentMsg.payload.asObjectFromJSONObject;
        releaseTx.wallet = wallet;
        [releaseTx sign];
        [releaseTx broadcast];
        
        MKBuyPostPaymentMsg *msg = [[MKBuyPostPaymentMsg alloc] init];
        [msg copyThreadFrom:self.buy.bidMsg];
        [self addChild:msg];
    }
}

// post refund

- (MKBuyPostRefundMsg *)buyPostRefundMsg
{
    return [self.children firstObjectOfClass:MKBuyPostRefundMsg.class];
}


- (void)signAndPostRefundToBlockChain
{
    BNWallet *wallet = [MKRootNode sharedMKRootNode].wallet;
    
    if (!wallet.isRunning)
    {
        return;
    }
    
    if (!self.buyPostRefundMsg)
    {
        BNTx *releaseTx = self.sellAcceptRefundRequestMsg.payload.asObjectFromJSONObject;
        releaseTx.wallet = wallet;
        [releaseTx sign];
        [releaseTx broadcast];
        
        MKBuyPostRefundMsg *msg = [[MKBuyPostRefundMsg alloc] init];
        [msg copyThreadFrom:self.buy.bidMsg];
        [self addChild:msg];
    }
}

@end
