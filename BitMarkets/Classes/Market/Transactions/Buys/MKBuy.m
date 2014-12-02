//
//  MKBuy.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/17/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKBuy.h"
#import "MKMsg.h"
#import "MKRootNode.h"

@implementation MKBuy

- (id)init
{
    self = [super init];
 
    self.bid = [[MKBuyBid alloc] init];
    [self addChild:self.bid];
    
    self.lockEscrow = [[MKBuyLockEscrow alloc] init];
    [self addChild:self.lockEscrow];
    
    self.delivery = [[MKBuyDelivery alloc] init];
    [self addChild:self.delivery];
    
    self.releaseEscrow = [[MKBuyReleaseEscrow alloc] init];
    [self addChild:self.releaseEscrow];
    
    self.complete = [[MKBuyComplete alloc] init];
    [self addChild:self.complete];
    
    self.nodeViewClass = MKTxProgressView.class;
    
    return self;
}

/*
- (void)update
{
    [super update];
    [self postParentChainChanged];
}
*/

- (MKStage *)currentStage
{
    MKStage *stage = [super currentStage];
    //NSLog(@"%@ currentStage %@", self.className, stage.className);
    return stage;
}

- (NSArray *)visibleStages
{
    NSMutableArray *visibleStages = [NSMutableArray arrayWithArray:self.children];
    [visibleStages removeFirstObject];
    return visibleStages;
}

- (BOOL)isCanceled
{
    return self.lockEscrow.isCancelConfirmed;
}

- (NSString *)nodeNote
{
    if (self.releaseEscrow.isComplete)
    {
        return @"✓";
    }
    
    if (self.isCanceled)
    {
        return @"✗";
    }
    
    return @"●";
}

- (NSString *)nodeSubtitle
{
    NSString *subtitle = [super nodeSubtitle];
    NSString *status = self.releaseEscrow.shortStatus;
    
    if (self.isCanceled)
    {
        status = @"canceled";
    }
    
    if (status)
    {
        subtitle = [NSString stringWithFormat:@"%@ %@", subtitle, status];
    }
    
    return subtitle;
}

- (void)setDict:(NSDictionary *)dict
{
    [super setDict:dict];
    
    self.bid           = [self.children firstObjectOfClass:MKBuyBid.class];
    self.lockEscrow    = [self.children firstObjectOfClass:MKBuyLockEscrow.class];
    self.delivery      = [self.children firstObjectOfClass:MKBuyDelivery.class];
    self.releaseEscrow = [self.children firstObjectOfClass:MKBuyReleaseEscrow.class];
}

// ----------------

- (NSString *)myAddress
{
    return MKRootNode.sharedMKRootNode.bmClient.identities.firstIdentity.address;
}

- (MKBidMsg *)bidMsg
{
    return self.bid.bidMsg;
}

// -------------------

- (BOOL)handleMsg:(MKMsg *)msg
{
    NSArray *myAddresses = BMClient.sharedBMClient.identities.identityAddresses;
    
    if ([myAddresses containsObject:msg.buyerAddress])
    {
        return [super handleMsg:msg];
    }

    return NO;
}

- (BOOL)isBuy
{
    return YES;
}

@end
