//
//  MKBuyDelivery.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKBuyDelivery.h"

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
    if (self.addressMsg)
    {
        return @"sent address";
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

- (MKBuyerAddressMsg *)addressMsg
{
    return [self.children firstObjectOfClass:MKBuyerAddressMsg.class];
}

@end
