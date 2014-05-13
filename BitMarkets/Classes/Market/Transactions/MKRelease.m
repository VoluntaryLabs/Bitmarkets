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

- (MKBuy *)buy
{
    MKBuy *buy = (MKBuy *)[self firstInParentChainOfClass:MKBuy.class];
    assert(buy != nil);
    return buy;
}

- (MKSell *)sell
{
    MKSell *sell = (MKSell *)[self firstInParentChainOfClass:MKSell.class];
    assert(sell != nil);
    return sell;
}

// node

- (NSString *)nodeTitle
{
    return @"Release Escrow";
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

- (MKBuyRequestRefundMsg *)buyRequestRefundMsg
{
    return [self.children firstObjectOfClass:MKBuyRequestRefundMsg.class];
}

- (MKSellAcceptRefundRequestMsg *)sellAcceptRefundRequestMsg
{
    return [self.children firstObjectOfClass:MKSellAcceptRefundRequestMsg.class];
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


@end
