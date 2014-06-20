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
#import "MKSellDeliveryAddress.h"

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
    return @"Dispatch";
}

- (BOOL)isComplete
{
    return self.addressMsg != nil;
}

- (BOOL)isActive
{
    return self.sell.lockEscrow.isComplete && !self.isComplete;
}

- (NSString *)nodeSubtitle
{
    if (self.addressMsg)
    {
        return @"received";
    }
    
    return @"awaiting delivery address from buyer";

    /*
    if (self.sell.lockEscrow.isComplete)
    {
        if (!self.addressMsg)
        {
            return @"awaiting delivery address";
        }
        
        if (self.addressMsg)
        {
            return @"received";
        }
    }
    else
    {
        if (self.addressMsg)
        {
            return @"received";
        }
    }
    
    return nil;
    */
}

- (NSString *)nodeNote
{
    if (self.isComplete)
    {
        return @"✓";
    }

    if (self.sell.lockEscrow.isComplete)
    {
        return @"●";
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
        if([self addChild:msg])
        {
            MKBuyerAddressMsg *addressMsg = (MKBuyerAddressMsg *)msg;
            MKSellDeliveryAddress *address = [[MKSellDeliveryAddress alloc] init];
            address.addressDict = [NSMutableDictionary dictionaryWithDictionary:addressMsg.addressDict];
            [self addChild:address];
        }

        [self update];
        return YES;
    }
    
    return NO;
}

- (void)update
{
    
}

@end
