//
//  MKBuyDeliveryAddress.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/7/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKBuyDeliveryAddress.h"
#import "MKDeliveryAddressView.h"

@implementation MKBuyDeliveryAddress

- (id)init
{
    self = [super init];
    
    self.addressDict = [NSMutableDictionary dictionary];
    
    return self;
}

- (NSString *)nodeTitle
{
    return @"Address";
}

- (NSString *)nodeSubtitle
{
    return @"need to complete";
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

@end
