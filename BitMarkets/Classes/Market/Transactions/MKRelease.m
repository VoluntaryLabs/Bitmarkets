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


@end
