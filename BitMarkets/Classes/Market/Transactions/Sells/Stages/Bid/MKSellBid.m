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
#import "MKLockEscrowInputMsg.h"

@implementation MKSellBid

- (id)init
{
    self = [super init];
    
    self.shouldSortChildren = NO;
    //self.sortChildrenKey = @"date";
    //self.sortAccending = YES;
    
    self.nodeViewClass = NavMirrorView.class;
    
    [self updateActions];
    
    return self;
}

- (void)update
{
    [self updateActions];
}

- (void)updateActions
{
    {
        BOOL enabled = self.runningWallet && !self.wasAccepted && !self.wasRejected;
        NavActionSlot *acceptSlot = [self.navMirror newActionSlotWithName:@"accept"];
        [acceptSlot setVisibleName:@"Accept Bid"];
        [acceptSlot setIsVisible:YES];
        [acceptSlot setIsActive:enabled];
    }
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

/*
- (NSArray *)modelActions
{
    //if (!self.wasAccepted && !self.wasRejected)
    {
        return @[@"accept"];
    }
    
    return @[];
}
*/

- (CGFloat)nodeSuggestedWidth
{
    return 450;
}

- (NSString *)nodeTitle
{
    return [NSString stringWithFormat:@"Bid from %@", self.bidMsg.buyerAddress];
}

- (NSString *)nodeSubtitle
{
    return self.status;
}

// --- status --------------------

- (NSString *)status
{
    if (self.error)
    {
        return self.error;
    }
    if (self.acceptMsg)
    {
        return [NSString stringWithFormat:@"accepted %@", self.acceptMsg.dateString];
    }
    else if (self.rejectMsg)
    {
        return @"rejected";
    }
    
    return @"ready to accept...";
}

- (MKAcceptBidMsg *)acceptMsg
{
    return [self.children firstObjectOfClass:MKAcceptBidMsg.class];
}

- (MKRejectBidMsg *)rejectMsg
{
    return [self.children firstObjectOfClass:MKRejectBidMsg.class];
}

- (BOOL)wasAccepted
{
    return self.acceptMsg != nil;
}

- (BOOL)wasRejected
{
    return self.rejectMsg != nil;
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

- (MKSell *)sell
{
    return [self firstInParentChainOfClass:MKSell.class];
}

- (MKBuyerLockEscrowMsg *)escrowInputTxMsg
{
    return [self.children firstObjectOfClass:MKLockEscrowInputMsg.class];
}

- (BNTx *)escrowInputTx
{
    BNTx *escrowInputTx = self.escrowInputTxMsg.payload.asObjectFromJSONObject;
    if (escrowInputTx)
    {
        escrowInputTx.wallet = self.runningWallet;
        return escrowInputTx;
    }
    else
    {
        return nil;
    };
}

- (void)setEscrowInputTx:(BNTx *)escrowInputTx
{
    MKLockEscrowInputMsg *escrowInputTxMsg = [[MKLockEscrowInputMsg alloc] init];
    [escrowInputTxMsg copyThreadFrom:self.bidMsg];
    escrowInputTxMsg.payload = escrowInputTx.asJSONObject;
    [self addChild:escrowInputTxMsg];
}


- (void)accept
{
    BNWallet *wallet = self.runningWallet;
    
    if (!wallet)
    {
        return;
    }
    

    MKSell *sell = self.sell; //(MKSell *)self.nodeParent.nodeParent;
    

    BNTx *escrowTx = [wallet newTx];
    
    BNTx *escrowInputTx = self.escrowInputTx;
    if (escrowInputTx)
    {
        [escrowInputTx fetch];
        if (escrowInputTx.isConfirmed)
        {
            [escrowTx configureForEscrowWithInputTx:escrowInputTx];
        }
        else
        {
            [self performSelector:@selector(accept) withObject:nil afterDelay:15];
            return;
        }
    }
    else
    {
        [escrowTx configureForEscrowWithValue:sell.mkPost.priceInSatoshi];
    }
    
    self.error = nil;
    if (escrowTx.error)
    {
        NSLog(@"tx configureForOutputWithValue failed: %@", escrowTx.error.description);
        
        if (escrowTx.error.insufficientValue)
        {
            self.error = [NSString stringWithFormat:@"%@BTC Required", escrowTx.error.insufficientValue.satoshiToBtc];
        }
        else
        {
            [NSException raise:@"tx configureForOutputWithValue failed" format:nil];
            //TODO: handle unknown tx configureForEscrowWithValue error
        }
        
        return;
    }
    
    [escrowTx subtractFee];
    
    if ([escrowTx changeValue].longLongValue > 10000)
    {
        //create an output that won't lock up more than needed
        escrowInputTx = [wallet newTx];
        [escrowInputTx configureForOutputWithValue:[NSNumber numberWithLongLong:
                                         [(BNTxOut *)[escrowTx.outputs firstObject] value].longLongValue + [escrowTx fee].longLongValue]];
        [escrowInputTx subtractFee];
        [escrowInputTx sign];
        [escrowInputTx broadcast]; //TODO make sure that peers accepted it
        [self setEscrowInputTx:escrowInputTx];
        [self performSelector:@selector(accept) withObject:nil afterDelay:15];
        return;
    }
    else
    {
        MKAcceptBidMsg *msg = [[MKAcceptBidMsg alloc] init];
        [msg copyThreadFrom:self.bidMsg];
        
        [escrowTx lockInputs];
        [msg setPayload:[escrowTx asJSONObject]];
        [msg send];
        [self addChild:msg];
        [self updateActions];
        [self.sell write];
        
        [self.sellBids setAcceptedBid:self];
        [self postSelfChanged];
    }
}

- (void)reject
{
    MKRejectBidMsg *msg = [[MKRejectBidMsg alloc] init];
    [msg copyThreadFrom:self.bidMsg];
    [msg send];
    
    [self addChild:msg];
    [self updateActions];
    [self.sell write];
}

- (BOOL)nodeShouldIndent
{
    return NO;
}

@end
