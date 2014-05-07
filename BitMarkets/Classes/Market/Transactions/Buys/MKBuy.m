//
//  MKBuy.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/17/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
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
    
    return self;
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

- (NSString *)nodeTitle
{
    return self.mkPost.titleOrDefault;
}

- (NSString *)nodeSubtitle
{
    return nil;
}


// -------------------


@end
