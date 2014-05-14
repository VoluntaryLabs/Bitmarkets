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

//messages

- (MKBuyerLockEscrowMsg *)buyerLockMsg
{
    return [self.children firstObjectOfClass:MKBuyerLockEscrowMsg.class];
}

- (MKSellerLockEscrowMsg *)sellerLockMsg
{
    return [self.children firstObjectOfClass:MKSellerLockEscrowMsg.class];
}

- (MKConfirmLockEscrowMsg *)confirmMsg
{
    return [self.children firstObjectOfClass:MKConfirmLockEscrowMsg.class];
}

- (BOOL)sendLock
{
    BNWallet *wallet = MKRootNode.sharedMKRootNode.wallet;
    
    if (!wallet.isRunning)
    {
        return YES; // this effectively just reports that the msg was valid
    }
    
    //NSLog(@"remove this return");
    //return YES; // temp
    
    MKSellerLockEscrowMsg *msg = [[MKSellerLockEscrowMsg alloc] init];
    [msg copyFrom:self.bidMsg];

    BNTx *buyerEscrowTx = [self.buyerLockMsg.payload asObjectFromJSONObject]; //TODO check errors.  TODO verify tx before signing.
    buyerEscrowTx.wallet = wallet;
    
    [buyerEscrowTx sign];
    [buyerEscrowTx broadcast];
    
    [msg sendToBuyer];
    [self addChild:msg];
    [self postSelfChanged];
    [self postParentChanged];
    return YES;
}

- (void)sendLockIfNeeded
{
    if (self.buyerLockMsg && !self.sellerLockMsg)
    {
        [self sendLock];
    }
}

- (void)update
{
    [self sendLockIfNeeded];
    [self lookForConfirmIfNeeded];
}

// confirm methods to extend parent class MKLock

- (MKBidMsg *)bidMsg
{
    return self.sell.bids.acceptedBid.bidMsg;
}

// confirm

- (NSDictionary *)payloadToConfirm
{
    return self.buyerLockMsg.payload;
}

- (BOOL)shouldLookForConfirm; // subclasses should override
{
    return (self.buyerLockMsg && !self.confirmMsg);
}

- (BOOL)isComplete
{
    return self.isConfirmed;
}


@end
