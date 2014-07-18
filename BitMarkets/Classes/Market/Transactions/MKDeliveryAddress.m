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
    [self addPropertyName:@"addressDict"];

    /*
    {
        NavDataSlot *slot = [self.navMirror newDataSlotWithName:@"addressee"];
        [slot setUneditedValue:@"Full Address"];
        [slot setVisibleName:@"Address"];
        [slot setLineCount:@5];
    }
    */
    
    {
        NavDataSlot *slot = [self.navMirror newDataSlotWithName:@"addressee"];
        [slot setUneditedValue:@"Name"];
        [slot setVisibleName:@"Name"];
    }
    
    {
        NavDataSlot *slot = [self.navMirror newDataSlotWithName:@"address1"];
        [slot setVisibleName:@"Street"];
        [slot setUneditedValue:@"Address"];
    }
    
    {
        NavDataSlot *slot = [self.navMirror newDataSlotWithName:@"address2"];
        [slot setVisibleName:@"Region"];
        [slot setUneditedValue:@"City, Province/State/County, Postal Code"];
    }
    
    {
        NavDataSlot *slot = [self.navMirror newDataSlotWithName:@"country"];
        [slot setVisibleName:@"Country"];
        [slot setUneditedValue:@"Country"];
    }
    
    {
        NavDataSlot *slot = [self.navMirror newDataSlotWithName:@"country"];
        [slot setVisibleName:@"Notes"];
        [slot setUneditedValue:@"Notes"];
    }
     
    
    return self;
}

- (void)updateActions
{
    
}

// addressDict

- (void)setAddressKey:(NSString *)key to:(NSString *)value
{
    if (value)
    {
        [self.addressDict setObject:value forKey:key];
    }
    else
    {
        [self.addressDict removeObjectForKey:key];
    }
    
    [self write];
}

// addressee

- (void)setAddressee:(NSString *)aString
{
    [self setAddressKey:@"addressee" to:aString];
}

- (NSString *)addressee
{
    return [self.addressDict objectForKey:@"addressee"];
}

// address1

- (void)setAddress1:(NSString *)aString
{
    [self setAddressKey:@"address1" to:aString];
}

- (NSString *)address1
{
    return [self.addressDict objectForKey:@"address1"];
}

// address2

- (void)setAddress2:(NSString *)aString
{
    [self setAddressKey:@"address2" to:aString];
}

- (NSString *)address2
{
    return [self.addressDict objectForKey:@"address2"];
}

// country

- (void)setCountry:(NSString *)aString
{
    [self setAddressKey:@"country" to:aString];
}

- (NSString *)country
{
    return [self.addressDict objectForKey:@"country"];
}

// checks

- (BOOL)isFilled
{
    for (NavDataSlot *dataSlot in self.navMirror.dataSlots)
    {
        if ([dataSlot hasEmptyValue])
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
