//
//  MKSellLockEscrow.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKSellLockEscrow.h"
#import "MKSell.h"
#import "MKBuyerLockEscrowMsg.h"
#import "MKSellerLockEscrowMsg.h"
#import "MKRootNode.h"
#import <BitnashKit/BitnashKit.h>
#import "MKConfirmLockEscrowMsg.h"

@implementation MKSellLockEscrow

- (id)init
{
    self = [super init];
    return self;
}

- (CGFloat)nodeSuggestedWidth
{
    return 350;
}

- (NSString *)nodeTitle
{
    return @"Lock Escrow";
}

- (NSString *)nodeSubtitle
{
    if (self.sellerLockMsg)
    {
        return @"awaiting blockchain confirm";
    }
    
    if (self.buyerLockMsg)
    {
        return @"got buyer lock";
    }
    
    if (self.sell.bids.acceptedBid)
    {
        return @"awaiting buyer lock";
    }
    
    return nil;
}

- (void)sortChildren
{
    [super sortChildrenWithKey:@"date"];
}

// --------------------

- (MKSell *)sell
{
    return (MKSell *)self.nodeParent;
}

- (BOOL)handleMsg:(MKMsg *)msg
{
    if ([msg isKindOfClass:MKBuyerLockEscrowMsg.class])
    {
        [self addChild:msg];
        [self update];
        return YES;
    }
    
    return NO;
}

- (MKBuyerLockEscrowMsg *)buyerLockMsg
{
    return [self.children firstObjectOfClass:MKBuyerLockEscrowMsg.class];
}

- (MKSellerLockEscrowMsg *)sellerLockMsg
{
    return [self.children firstObjectOfClass:MKSellerLockEscrowMsg.class];
}

- (MKConfirmLockEscrowMsg *)confirmLockMsg
{
    return [self.children firstObjectOfClass:MKConfirmLockEscrowMsg.class];
}

- (BOOL)sendLock
{
    NSDictionary *payload = self.buyerLockMsg.payload;
    
    MKSellerLockEscrowMsg *msg = [[MKSellerLockEscrowMsg alloc] init];
    [msg copyFrom:self.sell.bids.acceptedBid.bidMsg];

    BNWallet *wallet = MKRootNode.sharedMKRootNode.wallet;
    [msg setPayload:@"..."];
    
    [msg sendToBuyer];
    [self addChild:msg];
    [self postSelfChanged];
    [self postParentChanged];
    return YES;
}

- (void)update
{
    if (self.buyerLockMsg && !self.sellerLockMsg)
    {
        [self sendLock];
    }
}

- (BOOL)isConfirmed
{
    return NO;
}

- (void)lookForConfirm
{
    
}



@end
