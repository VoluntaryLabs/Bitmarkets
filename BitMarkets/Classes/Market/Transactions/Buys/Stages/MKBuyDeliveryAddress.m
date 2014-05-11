//
//  MKBuyDeliveryAddress.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/7/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKBuyDeliveryAddress.h"
#import "MKDeliveryAddressView.h"
#import "MKBuyerAddressMsg.h"
#import "MKBuyDelivery.h"
#import "MKBuy.h"

@implementation MKBuyDeliveryAddress

- (id)init
{
    self = [super init];
    
    [self.dictPropertyNames addObject:@"addressDict"];
    [self read];

    if (self.addressDict == nil)
    {
        self.addressDict = [NSMutableDictionary dictionary];
        
    }
    
    return self;
}

- (NSString *)nodeTitle
{
    return @"Address To Send";
}

- (NSString *)nodeSubtitle
{
    if (self.isFilled)
    {
        return @"completed";
    }
    
    return @"need to complete";
}

- (NSString *)nodeNote
{
    if (self.isFilled)
    {
        //return @"✓";
    }
    
    return nil;
}

- (Class)nodeViewClass
{
    return MKDeliveryAddressView.class;
}

- (JSONDB *)db
{
    JSONDB *db = [super db];
    db.name = @"address";
    db.location = JSONDB_IN_APP_SUPPORT_FOLDER;
    return db;
}

- (MKBuyDelivery *)delivery
{
    return (MKBuyDelivery *)self.nodeParent;
}

- (void)sendMsg
{
    MKBuyerAddressMsg *msg = [[MKBuyerAddressMsg alloc] init];
    [msg copyFrom:self.delivery.buy.bid.bidMsg];
    [msg.dict setObject:self.addressDict forKey:@"address"];
    [msg send];
    [self.delivery addChild:msg];
    //return msg;
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


- (BOOL)isInBuy
{
    return [self.nodeParent.className containsString:@"Buy"];
}

- (BOOL)canSend
{
    if (self.isInBuy)
    {
        MKBuyDelivery *delivery = (MKBuyDelivery *)self.nodeParent;
        
        if (delivery.addressMsg)
        {
            
        }
    }
    
    return self.isFilled && self.isInBuy;
}

@end
