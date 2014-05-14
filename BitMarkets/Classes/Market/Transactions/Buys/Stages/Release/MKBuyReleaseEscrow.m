//
//  MKBuyReleaseEscrow.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKBuyReleaseEscrow.h"
#import "MKBuy.h"

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
        [msg isKindOfClass:MKSellAcceptRefundRequestMsg.class])
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

// initiate release

- (void)requestRefund // user initiated
{
    MKBuyRefundRequestMsg *msg = [[MKBuyRefundRequestMsg alloc] init];
    [msg copyFrom:self.buy.bid.bidMsg];
    [msg send];
    
    [self addChild:msg];
}

- (void)makePayment // user initiated
{
    MKBuyPaymentMsg *msg = [[MKBuyPaymentMsg alloc] init];
    [msg copyFrom:self.buy.bid.bidMsg];
    [msg send];
    
    [self addChild:msg];
}

// sign and post

- (void)signAndPostAcceptToBlockChain
{
    
}

- (void)signAndPostRefundToBlockChain
{
    
}

@end
