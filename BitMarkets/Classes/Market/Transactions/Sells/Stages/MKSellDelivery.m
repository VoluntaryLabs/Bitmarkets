//
//  MKSellDelivery.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKSellDelivery.h"
#import "MKBuyerAddressMsg.h"
#import "MKSell.h"

@implementation MKSellDelivery

- (id)init
{
    self = [super init];
    return self;
}

- (MKSell *)sell
{
    return (MKSell *)self.nodeParent;
}

- (NSString *)nodeTitle
{
    return @"Delivery";
}

- (BOOL)isComplete
{
    return self.addressMsg != nil;
}

- (NSString *)nodeSubtitle
{
    if (self.sell.lockEscrow.isComplete)
    {
        if (!self.addressMsg)
        {
            return @"awaiting delivery address";
        }
        
        if (self.addressMsg)
        {
            return @"ready to deliver!";
        }
    }
    else
    {
        if (self.addressMsg)
        {
            return @"received address";
        }
    }
    
    return nil;
}

- (NSString *)nodeNote
{
    if (self.isComplete)
    {
        return @"✓";
    }
    
    return nil;
}

- (MKBuyerAddressMsg *)addressMsg
{
    return [self.children firstObjectOfClass:MKBuyerAddressMsg.class];
}

- (BOOL)handleMsg:(MKMsg *)msg
{
    if ([msg isKindOfClass:MKBuyerAddressMsg.class])
    {
        [self addChild:msg];
        [self update];
        return YES;
    }
    
    return NO;
}

- (void)update
{
    
}

@end
