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

// name

- (void)setName:(NSString *)aString
{
    [self.addressDict setObject:aString forKey:@"name"];
}

- (NSString *)name
{
    return [self.addressDict objectForKey:@"name"];
}

// address1

- (void)setAddress1:(NSString *)aString
{
    [self.addressDict setObject:aString forKey:@"address1"];
}

- (NSString *)address1
{
    return [self.addressDict objectForKey:@"address1"];
}

// address2

- (void)setAddress2:(NSString *)aString
{
    [self.addressDict setObject:aString forKey:@"address2"];
}

- (NSString *)address2
{
    return [self.addressDict objectForKey:@"address2"];
}

// country

- (void)setCountry:(NSString *)aString
{
    [self.addressDict setObject:aString forKey:@"country"];
}

- (NSString *)country
{
    return [self.addressDict objectForKey:@"country"];
}



// checks

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
