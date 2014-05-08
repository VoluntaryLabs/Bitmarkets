//
//  MKBuyLockEscrow.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKBuyLockEscrow.h"
#import "MKBuyerLockEscrowMsg.h"
#import "MKBuy.h"
#import "MKSellerLockEscrowMsg.h"
#import "MKBuyerPostLockEscrowMsg.h"

#import "MKRootNode.h"
#import <BitnashKit/BitnashKit.h>
#import "MKConfirmLockEscrowMsg.h"

@implementation MKBuyLockEscrow

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
        return @"sent - awaiting reply";
    }
    
    return nil;
}

- (MKBuy *)buy
{
    return (MKBuy *)self.nodeParent;
}

// messages

- (MKBuyerLockEscrowMsg *)buyerLockMsg
{
    return [self.children firstObjectOfClass:MKBuyerLockEscrowMsg.class];
}

- (MKSellerLockEscrowMsg *)sellerLockMsg
{
    return [self.children firstObjectOfClass:MKSellerLockEscrowMsg.class];
}

- (MKBuyerPostLockEscrowMsg *)buyerPostLockMsg
{
    return [self.children firstObjectOfClass:MKBuyerPostLockEscrowMsg.class];
}

- (MKConfirmLockEscrowMsg *)confirmMsg
{
    return [self.children firstObjectOfClass:MKConfirmLockEscrowMsg.class];
}

// ---------------------

- (BOOL)handleMsg:(MKMsg *)msg
{
    if ([msg isKindOfClass:MKSellerLockEscrowMsg.class])
    {
        [self addChild:msg];
        [self update];
        return YES;
    }
    
    return NO;
}

- (BOOL)isConfirmed
{
    return NO;
}

- (void)update
{
    if (self.buy.bid.wasAccepted && !self.buyerLockMsg)
    {
        [self sendLockToSeller];
    }
    else if (self.sellerLockMsg && !self.buyerPostLockMsg)
    {
        [self postLockToBlockchain];
    }
}

// send lock

- (BOOL)didSendLock
{
    return self.buyerLockMsg != nil;
}

- (BOOL)sendLockToSeller
{
    NSDictionary *bidPayload = self.buy.bid.acceptMsg.payload;
    
    
    MKBuyerLockEscrowMsg *msg = [[MKBuyerLockEscrowMsg alloc] init];
    [msg copyFrom:self.buy.bid.bidMsg];
    
    BNWallet *wallet = MKRootNode.sharedMKRootNode.wallet;
    
    [msg setPayload:@"[place lock 1 payload here]"];
    [msg sendToSeller];
    [self addChild:msg];
    
    return YES;
}

// post lock

- (BOOL)postLockToBlockchain
{
    NSDictionary *payload = self.sellerLockMsg.payload;
    
    MKBuyerPostLockEscrowMsg *msg = [[MKBuyerPostLockEscrowMsg alloc] init];
    [msg copyFrom:self.buy.bid.bidMsg];
    
    [msg setupFromSellerPayload:self.sellerLockMsg.payload];
    [msg postToBlockchain];
    
    [self addChild:msg];
    
    return NO;
}

- (void)sortChildren
{
    [super sortChildrenWithKey:@"date"];
}

- (void)lookForConfirm
{
    if (!self.confirmMsg)
    {
        BOOL isConfirmed = NO;
        
        // add look for confirm code
        
        if (isConfirmed)
        {
            MKConfirmLockEscrowMsg *msg = [[MKConfirmLockEscrowMsg alloc] init];
            [msg copyFrom:self.buy.bid.bidMsg];
            [self addChild:msg];
        }
    }
}


@end
