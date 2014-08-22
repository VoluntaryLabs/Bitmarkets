//
//  MKBuyDelivery.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKBuyDelivery.h"
#import "MKBuy.h"
#import "MKPanelManager.h"

@implementation MKBuyDelivery

- (id)init
{
    self = [super init];
    
    MKBuyDeliveryAddress *address = [[MKBuyDeliveryAddress alloc] init];
    [self addChild:address];
    
    NavActionSlot *slot = [self.navMirror newActionSlotWithName:@"enterAddress"];
    [slot setVisibleName:@"Enter Address"];
    
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
    return @"Address";
}


- (NSString *)nodeSubtitle
{
    if (!self.address.isApproved)
    {
        return @"Seller accepted bid. Enter your delivery address.";
    }
    
    if (self.addressMsg)
    {
        return @"Delivery address sent.";
    }
    
    return nil;
}

- (NSString *)nodeNote
{
    if (self.addressMsg)
    {
        return @"✓";
    }
    
    if (self.buy.lockEscrow.isComplete)
    {
        return @"●";
    }
    
    return nil;
}

- (MKBuy *)buy
{
    return (MKBuy *)self.nodeParent;
}

- (void)update
{
    [self updateActions];
}

- (void)updateActions
{
    NavActionSlot *slot = [self.navMirror newActionSlotWithName:@"enterAddress"];
    [slot setIsActive:!self.isComplete];
}

- (BOOL)isActive
{
    return self.buy.lockEscrow.isComplete && !self.isComplete;
}

- (BOOL)isApproved
{
    return self.addressMsg != nil;
}

- (void)sendAddress
{
    if (!self.isApproved)
    {
        MKBuyerAddressMsg *msg = [[MKBuyerAddressMsg alloc] init];
        [msg copyThreadFrom:self.buy.bidMsg];
        [msg setAddressDict:self.address.addressDict];
        
        if ([msg send])
        {
            [self addChild:msg];
            [self postParentChainChanged];
        }
    }
}

- (BOOL)isComplete
{
    return self.isApproved;
}

- (void)enterAddress // this shouldn't be at the model level
{
    MKPanelView *panel = [[MKPanelManager sharedPanelManager] openNewPanel];
    
    //NSView *addressView = self.address.nodeView;
    
    [panel setInnerView:self.address.nodeView];
    [self.nodeView addSubview:panel];
    [panel layout];
}

@end
