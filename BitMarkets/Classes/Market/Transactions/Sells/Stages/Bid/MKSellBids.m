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

@implementation MKSellBids

- (id)init
{
    self = [super init];
    self.shouldUseCountForNodeNote = YES;
    self.shouldSortChildren = YES;
    self.sortChildrenKey = @"date";
    self.sortAccending = NO;
    return self;
}

- (NSString *)nodeTitle
{
    return @"Bids";
}

- (CGFloat)nodeSuggestedWidth
{
    return 350.0;
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
        return @"accepted bid";
    }
    
    if (self.children.count > 0)
    {
        return @"choose bid";
    }
    
    return @"awaiting bids";
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
    return self.sell.mkPost.isPosted && !self.acceptedBid;
}

// close post

- (void)sendClosePost
{
    MKClosePostMsg *msg = [[MKClosePostMsg alloc] init];
    [msg copyFrom:self.sell.acceptedBidMsg];
    
    [msg sendFromSellerToChannel];
}

- (MKClosePostMsg *)closePostMsg
{
    return [self.children firstObjectOfClass:MKClosePostMsg.class];
}

@end
