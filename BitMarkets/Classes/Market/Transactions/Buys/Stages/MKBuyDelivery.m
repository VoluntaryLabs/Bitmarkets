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

- (MKBuyDeliveryAddress *)address
{
    return [self.children firstObjectOfClass:MKBuyDeliveryAddress.class];
}

- (NSString *)nodeTitle
{
    return @"Delivery";
}

@end
