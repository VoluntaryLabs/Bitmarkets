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

@implementation MKBuyReleaseEscrow

/*
- (id)init
{
    self = [super init];
    return self;
}
*/


- (NSString *)nodeSubtitle
{
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
    return (self.buyPaymentMsg || self.buyRequestRefundMsg) && !self.isComplete;
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

- (NSArray *)modelActions
{
    return @[@"requestRefund", @"makePayment"];
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
    if (self.sellAcceptPaymentMsg)
    {
        [self signAndPostAcceptToBlockChain];
    }
    
    if (self.sellAcceptRefundRequestMsg)
    {
        [self signAndPostRefundToBlockChain];
    }
    
}

// initiate payemnt

- (void)makePayment // user initiated
{
    //self.buy.lockEscrow.pos
    
    BNWallet *wallet = MKRootNode.sharedMKRootNode.wallet;
    
    if (!wallet.isRunning)
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
    [msg copyFrom:self.buy.bidMsg];
    [msg sendToSeller];
    
    [self addChild:msg];
}

// initiate refund

- (void)requestRefund // user initiated
{
    NSDictionary *payload = nil;
    
    if (!payload)
    {
        [NSException raise:@"missing payment payload" format:nil];
    }
    
    MKBuyRefundRequestMsg *msg = [[MKBuyRefundRequestMsg alloc] init];
    [msg copyFrom:self.buy.bidMsg];
    [msg setPayload:payload];
    [msg sendToSeller];
    
    [self addChild:msg];
}

// sign and post

- (void)signAndPostAcceptToBlockChain
{
    BNTx *releaseTx = self.sellAcceptPaymentMsg.payload.asObjectFromJSONObject;
    [releaseTx sign];
    [releaseTx broadcast];
}

- (void)signAndPostRefundToBlockChain
{
    
}

@end
