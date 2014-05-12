//
//  MKSellBid.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKSellBid.h"
#import "MKSell.h"
#import "MKAcceptBidMsg.h"
#import "MKRejectBidMsg.h"
#import "MKRootNode.h"

@implementation MKSellBid

- (id)init
{
    self = [super init];
    
    self.shouldSortChildren = YES;
    self.sortChildrenKey = @"date";
    self.sortAccending = YES;
    
    [self.dictPropertyNames addObject:@"status"];
    
    return self;
}

// --- equality ---

- (MKBidMsg *)bidMsg
{
    return self.children.firstObject;
}
   
- (NSUInteger)hash
{
    return self.bidMsg.hash;
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:MKSellBid.class])
    {
        MKSellBid *otherSellBid = object;
        BOOL isEqual = [self.bidMsg isEqual:otherSellBid.bidMsg];
        return isEqual;
    }
    
    return YES;
}

// --- UI ------------------------------

- (NSArray *)modelActions
{
    //if (!self.wasAccepted && !self.wasRejected)
    {
        return @[@"accept"];
    }
    
    return @[];
}

- (CGFloat)nodeSuggestedWidth
{
    return 450;
}

- (NSString *)nodeTitle
{
    return @"Bid";
}

- (NSString *)nodeSubtitle
{
    return self.status;
}

// --- status --------------------

- (BOOL)wasAccepted
{
    return [self.status isEqualToString:@"accepted"];
}

- (BOOL)wasRejected
{
    return [self.status isEqualToString:@"rejected"];
}

- (NSString *)nodeNote
{
    if (self.wasAccepted)
    {
        return @"✓";
    }
    
    if (self.wasRejected)
    {
        return @"✗";
    }
    
    return nil;
}

- (MKSellBids *)sellBids
{
    return (MKSellBids *)self.nodeParent;
}


- (void)accept
{
    MKAcceptBidMsg *msg = [[MKAcceptBidMsg alloc] init];
    [msg copyFrom:self.bidMsg];

    BNWallet *wallet = MKRootNode.sharedMKRootNode.wallet;
    // create payload...
    
    BNTx *tx = [wallet newTx];
    
    MKSell *sell = (MKSell *)self.nodeParent.nodeParent;
    
    NSLog(@"sell.mkPost.priceInSatoshi.longLongValue: %lld", sell.mkPost.priceInSatoshi.longLongValue);
    
    [tx configureForEscrowWithValue:sell.mkPost.priceInSatoshi.longLongValue];
    
    if (tx.error)
    {
        NSLog(@"tx configureForEscrowWithValue failed: %@", tx.error.description);
        if (tx.error.insufficientValue)
        {
            //TODO: prompt user for deposit
            
        }
        else
        {
            [NSException raise:@"tx configureForEscrowWithValue failed" format:nil];
            //TODO: handle unknown tx configureForEscrowWithValue error
        }
    }
    
    [msg setPayload:[tx asJSONObject]];
    
    [msg send];
    [self addChild:msg];
    
    [self.sellBids setAcceptedBid:self];
    [self postSelfChanged];
}

- (void)reject
{
    MKRejectBidMsg *msg = [[MKRejectBidMsg alloc] init];
    [msg copyFrom:self.bidMsg];
    [msg send];
    
    [self setStatus:@"rejected"];
}

- (BOOL)nodeShouldIndent
{
    return NO;
}

@end
