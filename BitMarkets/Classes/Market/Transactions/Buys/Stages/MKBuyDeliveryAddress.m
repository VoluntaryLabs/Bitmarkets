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
    self.isApproved = [NSNumber numberWithBool:NO];
    self.isEditable = YES;
    
    [self.dictPropertyNames addObject:@"isApproved"];
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
    if (!self.isFilled)
    {
        return @"need to complete";
    }
    
    if (!self.isApproved)
    {
        return @"need to approve";
    }
    
    return @"approved";
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

- (MKBuyDelivery *)buyDelivery
{
    return (MKBuyDelivery *)self.nodeParent;
}
- (BOOL)canSend
{
    MKBuyDelivery *buyDelivery = (MKBuyDelivery *)self.nodeParent;
    
    if (buyDelivery.addressMsg)
    {
        
    }
    
    return self.isFilled;
}

- (void)approve
{
    [self setIsApproved:[NSNumber numberWithBool:YES]];
    [self.buyDelivery update];
    [self postParentChainChanged];
}

@end
