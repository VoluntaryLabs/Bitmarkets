//
//  MKSellReleaseEscrow.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKSellReleaseEscrow.h"

// payment

#import "MKBuyPaymentMsg.h"
#import "MKSellAcceptPaymentMsg.h"

// refund

#import "MKBuyRequestRefundMsg.h"
#import "MKSellAcceptRefundRequestMsg.h"


@implementation MKSellReleaseEscrow

- (id)init
{
    self = [super init];
    return self;
}

- (NSString *)nodeTitle
{
    return @"Release Escrow";
}

- (NSArray *)modelActions
{
    return @[];
}

- (void)sendRefund
{
    
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

@end
