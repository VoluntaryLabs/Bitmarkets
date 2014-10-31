//
//  MKSellReleaseEscrow.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKSellReleaseEscrow.h"
#import "MKSell.h"
#import <BitnashKit/BitnashKit.h>
#import "MKRootNode.h"

@implementation MKSellReleaseEscrow

- (id)init
{
    self = [super init];
    
    self.nodeViewClass = NavMirrorView.class;
    
    NavActionSlot *slot = [self.navMirror newActionSlotWithName:@"acceptRefundRequest"];
    [slot setVisibleName:@"Send Refund"];
    
    return self;
}

- (void)updateActions
{
    BOOL enabled = self.buyRequestRefundMsg != nil && !self.sellAcceptRefundRequestMsg;
    
    NavActionSlot *slot = [self.navMirror newActionSlotWithName:@"acceptRefundRequest"];
    [slot setIsActive:enabled];
    [slot setIsVisible:enabled];
}

- (NSString *)nodeSubtitle
{
    // note: that buyer posts to blockchain
    
    if (self.buyRequestRefundMsg)
    {
        if(self.sellAcceptRefundRequestMsg)
        {
            if (self.sellRejectRefundRequestMsg)
            {
                return @"Rejected refund request.";
            }
            
            if (self.confirmRefundMsg)
            {
                return @"Refunded buyer.";
            }
            else
            {
                return @"Refund sent, awaiting confirm.";
            }
        }
        
        return @"Buyer requests refund.";
    }
    
    if (self.buyPaymentMsg)
    {
        if(self.sellAcceptPaymentMsg)
        {
            if (self.confirmPaymentMsg)
            {
                return @"Buyer payment confirmed. Transaction complete.";
            }
            
            return @"Buyer payment signed. Awaiting confirmation.";
        }
        
        return @"Buyer initiated payment.";
    }
    
    if (self.isActive)
    {
        return @"Waiting for buyer to make payment or request refund.";
    }
    
    if (self.sell.isCanceled)
    {
        return nil;
    }
    
    if (!self.runningWallet)
    {
        return @"Waiting for wallet...";
    }
    
    return nil;
}

- (BOOL)isActive
{
    if (!self.sell.delivery.isComplete)
    {
        return NO;
    }
    
    return self.sell.lockEscrow.isComplete && !self.isComplete;
    //return (self.buyPaymentMsg || self.buyRequestRefundMsg) && !self.isComplete;
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
    if ([msg isKindOfClass:MKBuyPaymentMsg.class] ||
        [msg isKindOfClass:MKBuyRefundRequestMsg.class])
    {
        [self addChild:msg];
        [self update];
        [self updateActions];
        [self postParentChainChanged];
        return YES;
    }
    
    return NO;
}

- (void)update
{
    if (self.buyPaymentMsg && !self.sellAcceptPaymentMsg)
    {
        [self acceptPayment];
    }
    
    if (self.buyRequestRefundMsg)
    {
        // refund action is available and
        // user must use it to refund
    }
    
    [self lookForConfirmsIfNeeded];
    [self updateActions];
}

- (void)verifyReleaseToMeAtLeast:(long long)amountInSatoshi forTx:(BNTx *)tx
{
    BNTx *escrowTx = self.sell.lockEscrow.lockEscrowMsgToConfirm.tx;
    escrowTx.wallet = self.runningWallet;
    [escrowTx fetch]; //update subsuming tx
    if (escrowTx.subsumingTx)
    {
        escrowTx = escrowTx.subsumingTx;
    }
    
    assert(tx.inputs.count == 1);
    
    BNTxIn *txIn = (BNTxIn *)tx.inputs.firstObject;
    assert(txIn.previousOutIndex.intValue == 0);
    assert([txIn.previousTxHash isEqualToString:escrowTx.txHash]);
    
    long long sentToMe = 0;
    NSArray *keys = [self.runningWallet keys];
    
    for (BNTxOut *txOut in tx.outputs) {
        if (!txOut.scriptPubKey.isMultisig) {
            BNPayToAddressScriptPubKey *script = (BNPayToAddressScriptPubKey *)txOut.scriptPubKey;
            NSLog(@"scriptPubKey: %@", script.address);
            for (BNKey *bnKey in keys) {
                NSLog(@"wallet key: %@", bnKey.address);
                if ([bnKey.address isEqualToString:script.address]) {
                    sentToMe += txOut.value.longLongValue;
                }
            }
        }
    }
    
    assert(sentToMe - amountInSatoshi >= 0);
}

- (void)acceptPayment // automatic
{
    BNWallet *wallet = self.runningWallet;
    
    if (!wallet)
    {
        return;
    }
    
    BNTx *escrowTx = self.sell.lockEscrow.lockEscrowMsgToConfirm.tx;
    
    BNTx *releaseTx = self.buyPaymentMsg.tx;
    releaseTx.wallet = wallet;
    
    [releaseTx addPayToAddressOutputWithValue:[NSNumber numberWithLongLong:2*escrowTx.firstOutput.value.longLongValue/3]];
    
    [releaseTx subtractFee];
    [self verifyReleaseToMeAtLeast:2*self.sell.mkPost.priceInSatoshi.longLongValue - 20000
                             forTx:releaseTx];
    [releaseTx sign];
    releaseTx.txType = @"Payment";
    releaseTx.description = self.sell.description;
    
    MKSellAcceptPaymentMsg *msg = [[MKSellAcceptPaymentMsg alloc] init];
    [msg copyThreadFrom:self.sell.acceptedBidMsg];
    [msg setPayload:releaseTx.asJSONObject];
    [self addChild:msg];
    [msg sendToBuyer];
    [self postSelfChanged];
    [self postParentChainChanged];
}

- (void)acceptRefundRequest
{
    BNWallet *wallet = self.runningWallet;
    
    if (!wallet)
    {
        return;
    }
    
    BNTx *escrowTx = self.sell.lockEscrow.lockEscrowMsgToConfirm.tx;
    
    BNTx *refundTx = [self.buyRequestRefundMsg.payload asObjectFromJSONObject];
    refundTx.wallet = wallet;
    
    [refundTx addPayToAddressOutputWithValue:[NSNumber numberWithLongLong:escrowTx.firstOutput.value.longLongValue/3]];
    
    [refundTx subtractFee];
    [self verifyReleaseToMeAtLeast:self.sell.mkPost.priceInSatoshi.longLongValue - 20000
                             forTx:refundTx];
    [refundTx sign];
    refundTx.txType = @"Refund";
    refundTx.description = self.sell.description;
    
    MKSellAcceptRefundRequestMsg *msg = [[MKSellAcceptRefundRequestMsg alloc] init];
    [msg copyThreadFrom:self.sell.acceptedBidMsg];
    [msg setPayload:refundTx.asJSONObject];
    [self addChild:msg];
    [msg sendToBuyer];
    [self postSelfChanged];
    [self postParentChainChanged];
    [self updateActions];
}

- (void)rejectRefund
{
    BNWallet *wallet = self.runningWallet;
    
    if (!wallet)
    {
        return;
    }
    
    MKSellRejectRefundRequestMsg *msg = [[MKSellRejectRefundRequestMsg alloc] init];
    [msg copyThreadFrom:self.sell.acceptedBidMsg];
    [self addChild:msg];
    [msg sendToBuyer];
    [self postParentChainChanged];
}


@end
