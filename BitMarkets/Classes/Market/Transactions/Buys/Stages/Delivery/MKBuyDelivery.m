//
//  MKBuyDelivery.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKBuyDelivery.h"
#import "MKBuy.h"

@implementation MKBuyDelivery

- (id)init
{
    self = [super init];
    self.nodeTitle = @"Delivery";
    
    MKBuyDeliveryAddress *address = [[MKBuyDeliveryAddress alloc] init];
    [self addChild:address];
    
    return self;
}

// messages

- (MKBuyDeliveryAddress *)address
{
    return [self.children firstObjectOfClass:MKBuyDeliveryAddress.class];
}

- (MKBuyerAddressMsg *)addressMsg
{
    return [self.children firstObjectOfClass:MKBuyerAddressMsg.class];
}

// node

- (CGFloat)nodeSuggestedWidth
{
    return 300;
}

- (NSString *)nodeTitle
{
    return @"Delivery";
}


- (NSString *)nodeSubtitle
{
    if (!self.address.isApproved)
    {
        return @"need to approve";
    }
    
    if (self.addressMsg)
    {
        return @"approved and sent";
    }
    
    return nil;
}

- (NSString *)nodeNote
{
    if (self.addressMsg)
    {
        return @"✓";
    }
    
    return nil;
}

- (MKBuy *)buy
{
    return (MKBuy *)self.nodeParent;
}

- (void)update
{
    // send address msg if ready
    /*
    if (self.address.isApproved && !self.addressMsg)
    {
        MKBuyerAddressMsg *msg = [[MKBuyerAddressMsg alloc] init];
        [msg copyFrom:self.buy.bidMsg];
        [msg setAddressDict:self.address.addressDict];
        [msg send];
        [self addChild:msg];
    }
    */
}

- (BOOL)isApproved
{
    return self.addressMsg != nil;
}

- (void)sendAddress
{
    if (!self.isApproved)
    {
        MKBuyerAddressMsg *msg = [[MKBuyerAddressMsg alloc] init];
        [msg copyThreadFrom:self.buy.bidMsg];
        [msg setAddressDict:self.address.addressDict];
        [msg send];
        [self addChild:msg];
        [self postParentChainChanged];
    }
}

@end
