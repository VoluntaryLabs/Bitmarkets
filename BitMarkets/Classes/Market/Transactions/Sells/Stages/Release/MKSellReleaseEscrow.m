//
//  MKSellReleaseEscrow.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKSellReleaseEscrow.h"
#import "MKSell.h"

@implementation MKSellReleaseEscrow

- (id)init
{
    self = [super init];
    return self;
}

- (NSString *)nodeSubtitle
{
    //if (self.sellerLockMsg)
    {
        return @"awaiting blockchain confirm";
    }
    
    return nil;
}

- (NSArray *)modelActions
{
    return @[];
}

// update

- (BOOL)handleMsg:(MKMsg *)msg
{
    if ([msg isKindOfClass:MKBuyPaymentMsg.class] ||
        [msg isKindOfClass:MKBuyRequestRefundMsg.class])
    {
        [self addChild:msg];
        [self update];
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
    
    /*
    if (self.buyRequestRefundMsg)
    {
        // add accept payment action?
    }
    */
}

// actions

- (void)acceptPayment // automatic
{
    [self firstInParentChainOfClass:MKSell.class];
}

- (void)acceptRefundRequest
{
    //MKConfirmLockEscrowMsg *confirm = self.buy.lock.confirm
}


@end
