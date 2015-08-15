//
//  MKBuyDeliveryAddress.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/7/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKBuyDeliveryAddress.h"
//#import "MKDeliveryAddressView.h"
#import "MKBuyerAddressMsg.h"
#import "MKBuyDelivery.h"
#import "MKBuy.h"


@implementation MKBuyDeliveryAddress

- (id)init
{
    self = [super init];
    self.isEditable = YES;
    
    //self.nodeViewClass = MKDeliveryAddressView.class;
    self.nodeViewClass = NavMirrorView.class;

    [self read];

    if (self.addressDict == nil)
    {
        self.addressDict = [NSMutableDictionary dictionary];
    }
    
    /*
    [NSNotificationCenter.defaultCenter addObserver:self
                                             selector:@selector(changedDataSlotAttribute:)
                                                 name:@"changedDataSlotAttribute"
                                               object:self];
    */
    
    return self;
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)updatedSlot:aSlot
{
    [self updateApproveActionSlot];
}

- (void)setNodeParent:(NavNode *)nodeParent
{
    [super setNodeParent:nodeParent];
    [self updateApproveActionSlot];
}

- (void)updateApproveActionSlot
{
    NavActionSlot *slot = [self.navMirror newActionSlotWithName:@"approve"];
    [slot setVisibleName:@"Send Address to Seller"];
    slot.isActive = !self.isApproved && self.isFilled;
    [slot.slotView syncFromSlot];
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
    //db.serverFolder = [[BMServerProcess sharedBMServerProcess] bundleDataPath];
    return db;
}

- (MKBuyDelivery *)buyDelivery
{
    return (MKBuyDelivery *)self.nodeParent;
}

- (void)approve
{
    if (!self.isApproved)
    {
        [self.buyDelivery sendAddress];
        [self.buyDelivery update];
        [self postParentChainChanged];
        [self updateApproveActionSlot];
    }
}

- (BOOL)isEditable
{
    return !self.isApproved;
}

- (BOOL)isApproved
{
    return self.buyDelivery.isApproved;
}

@end
