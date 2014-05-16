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

- (NSDate *)date
{
    return self.bidMsg.date;
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
    BNWallet *wallet = self.runningWallet;
    
    if (!wallet)
    {
        return;
    }
    
    MKAcceptBidMsg *msg = [[MKAcceptBidMsg alloc] init];
    [msg copyFrom:self.bidMsg];

    MKSell *sell = (MKSell *)self.nodeParent.nodeParent;
    

    BNTx *escrowTx = [wallet newTx];
    
    if (self.escrowInputTx)
    {
        [escrowTx configureForEscrowWithInputTx:self.escrowInputTx];
    }
    else
    {
        [escrowTx configureForEscrowWithValue:sell.mkPost.priceInSatoshi];
    }
    
    
    if (escrowTx.error)
    {
        NSLog(@"tx configureForOutputWithValue failed: %@", escrowTx.error.description);
        if (escrowTx.error.insufficientValue)
        {
            //TODO: prompt user for deposit
            
        }
        else
        {
            [NSException raise:@"tx configureForOutputWithValue failed" format:nil];
            //TODO: handle unknown tx configureForEscrowWithValue error
        }
        return;
    }
    
    [escrowTx subtractFee];
    
    NSLog(@"CHANGE VALUE: %lld", [escrowTx changeValue].longLongValue);
    
    if ([escrowTx changeValue].longLongValue > 10000)
    {
        //create an output that won't lock up more than needed
        self.escrowInputTx = [wallet newTx];
        [self.escrowInputTx configureForOutputWithValue:[NSNumber numberWithLongLong:
                                         [(BNTxOut *)[escrowTx.outputs firstObject] value].longLongValue + [escrowTx fee].longLongValue]];
        [self.escrowInputTx subtractFee];
        [self.escrowInputTx sign];
        [self.escrowInputTx broadcast];
        [self accept]; //TODO verify that tx is in mempool first
    }
    else
    {
        //[escrowTx markInputsAsSpent]; TODO
        [msg setPayload:[escrowTx asJSONObject]];
        [msg send];
        [self addChild:msg];
        
        [self.sellBids setAcceptedBid:self];
        [self postSelfChanged];
    }
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
