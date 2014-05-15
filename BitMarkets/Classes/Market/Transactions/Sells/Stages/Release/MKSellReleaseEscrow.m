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
    return self;
}

/*
- (NSString *)nodeSubtitle
{
    if (self.buyPaymentMsg)
    {
        if (self.confirmPaymentMsg)
        {
            return @"payment confirmed";
        }
        
        return @"confirming payment";
    }
    
    if (self.buyRequestRefundMsg)
    {
        if (self.confirmRefundMsg)
        {
            return @"refund confirmed";
        }
        
        return @"confirming refund";
    }
    
    if (self.sell.lockEscrow.isConfirmed)
    {
        if (!self.sell.delivery.isComplete)
        {
            return nil;
        }
        
        return @"awaiting buyer";
    }
    
    return nil;
}
*/

- (NSString *)nodeSubtitle
{
    // note: that buyer posts to blockchain
    
    if (self.buyRequestRefundMsg)
    {
        if(self.sellAcceptRefundRequestMsg)
        {
            if (self.sellRejectRefundRequestMsg)
            {
                return @"rejected refund request";
            }
            
            if (self.confirmRefundMsg)
            {
                return @"refunded buyer";
            }
            else
            {
                return @"awaiting refund confirm";
            }
        }
        
        return @"buyer requests refund";
    }
    
    if (self.buyPaymentMsg)
    {
        if(self.sellAcceptPaymentMsg)
        {
            if (self.confirmPaymentMsg)
            {
                return @"buyer paid";
            }
            
            return @"awaiting payment confirm";
        }
        
        return @"buyer requests refund";
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

// actions

- (NSArray *)modelActions
{
    return @[];
}

// update

- (BOOL)handleMsg:(MKMsg *)msg
{
    if ([msg isKindOfClass:MKBuyPaymentMsg.class] ||
        [msg isKindOfClass:MKBuyRefundRequestMsg.class])
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
    if (self.buyPaymentMsg)
    {
        [self acceptPayment];
    }
    
    if (self.buyRequestRefundMsg)
    {
        // refund action is available and
        // user must use it to refund
    }
    
    if (self.sellAcceptPaymentMsg && !self.confirmPaymentMsg)
    {
        if (!self.sellRejectRefundRequestMsg)
        {
            [self lookForPaymentConfirm];
        }
    }

    if (self.sellAcceptPaymentMsg && !self.confirmPaymentMsg)
    {
        [self lookForRefundConfirm];
    }
    
}

- (void)lookForPaymentConfirm
{
    BOOL paymentConfirmed = NO;
    
    if (paymentConfirmed)
    {
        MKConfirmPaymentMsg *msg = [[MKConfirmPaymentMsg alloc] init];
        [msg copyFrom:self.sell.acceptedBidMsg];
        [self addChild:msg];
        [self postParentChainChanged];
    }
}

- (void)lookForRefundConfirm
{
    BNWallet *wallet = MKRootNode.sharedMKRootNode.wallet;
    
    if (!wallet.isRunning)
    {
        return;
    }
    
    BOOL paymentConfirmed = NO;
    
    if (paymentConfirmed)
    {
        MKConfirmRefundMsg *msg = [[MKConfirmRefundMsg alloc] init];
        [msg copyFrom:self.sell.acceptedBidMsg];
        [self addChild:msg];
        [self postParentChainChanged];
    }
}

// actions

- (void)acceptPayment // automatic
{
    BNWallet *wallet = MKRootNode.sharedMKRootNode.wallet;
    
    if (!wallet.isRunning)
    {
        return;
    }
    
    MKBuyPaymentMsg *buyPaymentMsg = self.buyPaymentMsg;
    
    NSDictionary *payload = nil;
    
    if (!payload)
    {
        [NSException raise:@"missing payment payload" format:nil];
    }
    
    MKSellAcceptPaymentMsg *msg = [[MKSellAcceptPaymentMsg alloc] init];
    [msg copyFrom:self.sell.acceptedBidMsg];
    [msg setPayload:payload];
    [self addChild:msg];
    [msg sendToBuyer];
    [self postParentChainChanged];
}

- (void)acceptRefundRequest
{
    BNWallet *wallet = MKRootNode.sharedMKRootNode.wallet;
    
    if (!wallet.isRunning)
    {
        return;
    }
    
    MKBuyRefundRequestMsg *buyRequestRefundMsg = self.buyRequestRefundMsg;
    
    NSDictionary *payload = nil;
    
    if (!payload)
    {
        [NSException raise:@"missing refund payload" format:nil];
    }
    
    MKSellRejectRefundRequestMsg *msg = [[MKSellRejectRefundRequestMsg alloc] init];
    [msg copyFrom:self.sell.acceptedBidMsg];
    [msg setPayload:payload];
    [self addChild:msg];
    [msg sendToBuyer];
    [self postParentChainChanged];
}

- (void)rejectRefund
{
    BNWallet *wallet = MKRootNode.sharedMKRootNode.wallet;
    
    if (!wallet.isRunning)
    {
        return;
    }
    
    MKSellRejectRefundRequestMsg *msg = [[MKSellRejectRefundRequestMsg alloc] init];
    [msg copyFrom:self.sell.acceptedBidMsg];
    [self addChild:msg];
    [msg sendToBuyer];
    [self postParentChainChanged];
}


@end
