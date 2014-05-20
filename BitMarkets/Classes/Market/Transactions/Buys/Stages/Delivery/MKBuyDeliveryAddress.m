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
    self.isApproved = NO;
    self.isEditable = YES;
    
    self.nodeViewClass = MKDeliveryAddressView.class;

    [self.dictPropertyNames addObject:@"isApprovedBool"];
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

- (void)approve
{
    [self setIsApproved:YES];
    [self.buyDelivery update];
    [self postParentChainChanged];
}

- (BOOL)isEditable
{
    return !self.isApproved;
}

- (void)setIsApproved:(BOOL)aBool
{
    [self setIsApprovedBool:[NSNumber numberWithBool:aBool]];
}

- (BOOL)isApproved
{
    return self.isApprovedBool.boolValue;
}

@end
