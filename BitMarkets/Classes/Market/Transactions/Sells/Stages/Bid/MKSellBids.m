//
//  MKSellBids.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKSellBids.h"
#import "MKMsg.h"
#import "MKBidMsg.h"
#import "MKAcceptBidMsg.h"
#import "MKSellBid.h"
#import "MKSell.h"
#import "MKClosePostMsg.h"
#import "MKSells.h"

@implementation MKSellBids

- (id)init
{
    self = [super init];
    self.nodeShouldUseCountForNodeNote = @YES;
    self.nodeShouldSortChildren = @YES;
    self.nodeSortChildrenKey = @"date";
    self.nodeSortAccending = @NO;
    
    {
        NavActionSlot *slot = [self.navMirror newActionSlotWithName:@"acceptFirstBid"];
        [slot setVisibleName:@"Accept First Bid"];
    }
    
    return self;
}

- (NSString *)nodeTitle
{
    return @"Bids";
}

- (NSNumber *)nodeSuggestedWidth
{
    return @380.0;
}

- (NSString *)nodeNote
{
    if (self.isActive)
    {
        return @"●";
    }
    
    if (self.acceptedBid)
    {
        return @"✓";
    }
    
    return nil;
}

- (NSString *)nodeSubtitle
{
    if (self.acceptedBid)
    {
        return @"Accepted bid";
    }
    
    if (!self.runningWallet)
    {
        return @"Awaiting wallet sync...";
    }
    
    if (self.children.count > 0)
    {
        if (!self.hasAmountNeeded)
        {
            return [NSString stringWithFormat:@"Insufficent funds for security deposit to accept bid, need to deposit %@BTC",
                    [self.amountNeeded.satoshiToBtc asFormattedStringWithFractionalDigits:4]];
        }
        
        return @"Choose bid";
    }
    
    if (self.sell.mkPost.isComplete)
    {
        return @"Awaiting bids";
    }
    
    return nil;
}

- (BOOL)handleMsg:(MKMsg *)msg
{
    if ([msg isKindOfClass:MKBidMsg.class])
    {
        MKSellBid *sellBid = [[MKSellBid alloc] init];

        [sellBid addChild:msg];

        if ([self acceptedBid] && ![sellBid isEqual:[self acceptedBid]])
        {
            [sellBid reject];
        }
        
        [self addChild:sellBid];
        [self postParentChanged];
        return YES;
    }
    
    return NO;
}

- (void)rejectUnacceptedBids
{
    MKSellBid *sellBid = self.acceptedBid;
    
    for (MKSellBid *bid in self.children)
    {
        if (bid != sellBid)
        {
            [bid reject];
        }
    }
}

/*
- (void)setAcceptedBid:(MKSellBid *)sellBid
{
    for (MKSellBid *bid in self.children)
    {
        if (bid != sellBid)
        {
            [bid reject];
        }
    }
    
    [self sendClosePost];
    
    [self postSelfChanged];
    [self postParentChanged];
}
*/

- (MKSellBid *)acceptedBid
{
    for (MKSellBid *bid in self.children)
    {
        if ([bid wasAccepted])
        {
            return bid;
        }
    }
    
    return nil;
}

- (MKSell *)sell
{
    return (MKSell *)self.nodeParent;
}

- (BOOL)isActive
{
    return self.sell.mkPost.isComplete && !self.acceptedBid;
}

- (BOOL)isComplete
{
    return self.acceptedBid != nil;
}

// close post

- (void)sendClosePost
{
    MKClosePostMsg *msg = [[MKClosePostMsg alloc] init];
    [msg copyThreadFrom:self.sell.mkPost.postMsg];
    //NSLog(@"MKClosePostMsg postUuid %@", msg.postUuid);

    [msg sendFromSellerToChannel];
}

- (MKClosePostMsg *)closePostMsg
{
    return [self.children firstObjectOfClass:MKClosePostMsg.class];
}

- (void)update
{
    for (MKSellBid *bid in self.children)
    {
        [bid update];
    }
    
    [self updateActions];
}

- (void)updateActions
{
    {
        NavActionSlot *slot = [self.navMirror newActionSlotWithName:@"acceptFirstBid"];
        [slot setVisibleName:@"Accept First Bid"];
        
        BOOL active = (self.firstBid != nil) &&
            (self.acceptedBid == nil) &&
            (self.runningWallet != nil) &&
            self.hasAmountNeeded;
        
        [slot setIsActive:active];
    }

    {
        NavActionSlot *removeSlot = [self.navMirror newActionSlotWithName:@"removePost"];
        [removeSlot setVisibleName:@"Remove Listing"];
        [removeSlot setVerifyMessage:@"Are you sure you want to delete this listing?"];
        [removeSlot setIsVisible:YES];
        [removeSlot setIsActive:!self.acceptedBid];
    }
}

- (MKSellBid *)firstBid
{
    MKSellBid *bid = self.children.firstObject;
    return bid;
}

- (BOOL)hasAmountNeeded
{
    return [self.runningWallet.balance isGreaterThanOrEqualTo:self.amountNeeded];
}

- (NSNumber *)amountNeeded
{
    return [NSNumber numberWithLongLong:self.sell.mkPost.priceInSatoshi.longLongValue * 2];
}

- (void)acceptFirstBid
{
    MKSellBid *bid = self.firstBid;
    
    if (bid)
    {
        if (!self.hasAmountNeeded)
        {
            [self showInsufficientFundsPanel];
            return;
        }
        
        [bid accept];
        [self sendClosePost];
    }
    
    [self update];
    [self postParentChainChanged];
}

- (void)showInsufficientFundsPanel
{
    [NSException raise:@"insufficient funds for bid - this action shouldn't be possible" format:@""];
}

- (void)removePost
{
    [self sendClosePost];
    [self.sell.sells removeChild:self.sell];
}

@end
