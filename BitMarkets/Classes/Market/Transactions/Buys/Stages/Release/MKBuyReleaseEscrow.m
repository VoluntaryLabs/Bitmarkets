//
//  MKBuyReleaseEscrow.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKBuyReleaseEscrow.h"

@implementation MKBuyReleaseEscrow

/*
- (id)init
{
    self = [super init];
    return self;
}
*/

- (NSString *)nodeTitle
{
    return @"Release Escrow";
}

- (NSArray *)modelActions
{
    return @[@"requestRefund", @"makePayment"];
}

- (BOOL)handleMsg:(MKMsg *)msg
{
    if ([msg isKindOfClass:MKSellAcceptPaymentMsg.class] ||
        [msg isKindOfClass:MKSellAcceptRefundRequestMsg.class])
    {
        [self addChild:msg];
        [self update];
        return YES;
    }
    
    return NO;
}


- (void)update
{
    if (self.sellAcceptPaymentMsg)
    {
        
    }
    
    if (self.sellAcceptRefundRequestMsg)
    {
        
    }
}

- (void)requestRefund // user initiated
{
    
}

- (void)makePayment // user initiated
{
    
}

@end
