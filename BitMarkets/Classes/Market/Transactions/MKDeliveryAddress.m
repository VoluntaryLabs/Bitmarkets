//
//  MKDeliveryAddress.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/7/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKDeliveryAddress.h"
#import "MKBuyerAddressMsg.h"
#import "MKBuyDelivery.h"
#import "MKBuy.h"

@implementation MKDeliveryAddress

- (id)init
{
    self = [super init];
    self.addressDict = [NSMutableDictionary dictionary];
    [self.dictPropertyNames addObject:@"addressDict"];

    {
        NavActionSlot *slot = [self.navMirror newActionSlotWithName:@"send"];
        [slot setVisibleName:@"Send Address to Seller"];
    }
    
    {
        NavDataSlot *slot = [self.navMirror newDataSlotWithName:@"name"];
        [slot setUneditedValue:@"Name"];
        [slot setVisibleName:@"Name"];
    }
    
    {
        NavDataSlot *slot = [self.navMirror newDataSlotWithName:@"address1"];
        [slot setVisibleName:@"Street address"];
        [slot setUneditedValue:@"Address Line 1"];
    }
    
    {
        NavDataSlot *slot = [self.navMirror newDataSlotWithName:@"address2"];
        [slot setVisibleName:@"City, province/state/county, postal code"];
        [slot setUneditedValue:@"Address Line 2"];
    }
    
    {
        NavDataSlot *slot = [self.navMirror newDataSlotWithName:@"country"];
        [slot setVisibleName:@"Country"];
        [slot setUneditedValue:@"Country"];
    }
         
    return self;
}

- (BOOL)isFilled
{
    for (NSString *key in self.addressDict)
    {
        NSString *value = [self.addressDict objectForKey:key];
        if (!value || [value isEqualToString:@""])
        {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)canSend
{
    return NO;
}

@end
