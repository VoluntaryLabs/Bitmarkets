//
//  MKRelease.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/13/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKRelease.h"
#import "MKBuy.h"
#import "MKSell.h"


@implementation MKRelease

// node

- (NSString *)nodeTitle
{
    return @"Release Escrow";
}

- (NSString *)shortStatus
{
    if (self.confirmRefundMsg)
    {
        return @"refunded";
    }
    
    if (self.confirmPaymentMsg)
    {
        return @"paid";
    }
    
    return nil;
}

// checks

- (BOOL)wasPaid
{
    return self.confirmPaymentMsg != nil;
}

- (BOOL)wasRefunded
{
    return self.confirmRefundMsg != nil;
}

// payment messages

- (MKBuyPaymentMsg *)buyPaymentMsg
{
    return [self.children firstObjectOfClass:MKBuyPaymentMsg.class];
}

- (MKSellAcceptPaymentMsg *)sellAcceptPaymentMsg
{
    return [self.children firstObjectOfClass:MKSellAcceptPaymentMsg.class];
}



// refund messages

- (MKBuyRefundRequestMsg *)buyRequestRefundMsg
{
    return [self.children firstObjectOfClass:MKBuyRefundRequestMsg.class];
}

- (MKSellAcceptRefundRequestMsg *)sellAcceptRefundRequestMsg
{
    return [self.children firstObjectOfClass:MKSellAcceptRefundRequestMsg.class];
}

- (MKSellRejectRefundRequestMsg *)sellRejectRefundRequestMsg
{
    return [self.children firstObjectOfClass:MKSellRejectRefundRequestMsg.class];
}


// confirm

- (MKConfirmRefundMsg *)confirmRefundMsg
{
    return [self.children firstObjectOfClass:MKConfirmRefundMsg.class];
}

- (MKConfirmPaymentMsg *)confirmPaymentMsg
{
    return [self.children firstObjectOfClass:MKConfirmPaymentMsg.class];
}

// ---------------------

- (void)lookForConfirmsIfNeeded
{
    [self lookForPaymentConfirmIfNeeded];
    [self lookForRefundConfirmIfNeeded];
}

- (void)lookForPaymentConfirmIfNeeded
{
    if (self.sellAcceptPaymentMsg && !self.confirmPaymentMsg)
    {
        BOOL paymentConfirmed = self.sellAcceptPaymentMsg.isPayloadConfirmed;
        
        if (paymentConfirmed)
        {
            MKConfirmPaymentMsg *msg = [[MKConfirmPaymentMsg alloc] init];
            //[msg copyFrom:self.sellAcceptPaymentMsg];
            [self addChild:msg];
            [self postParentChainChanged];
        }
    }
}

- (void)lookForRefundConfirmIfNeeded
{
    if (self.sellAcceptRefundRequestMsg && !self.confirmRefundMsg)
    {
        BOOL refundConfirmed = self.sellAcceptRefundRequestMsg.isPayloadConfirmed;
        
        if (refundConfirmed)
        {
            MKConfirmRefundMsg *msg = [[MKConfirmRefundMsg alloc] init];
            //[msg copyFrom:self.sellAcceptPaymentMsg];
            [self addChild:msg];
            [self postParentChainChanged];
        }
    }
}

@end
