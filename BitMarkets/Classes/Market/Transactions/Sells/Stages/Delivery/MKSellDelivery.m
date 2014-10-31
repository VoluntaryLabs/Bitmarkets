//
//  MKSellDelivery.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKSellDelivery.h"
#import "MKBuyerAddressMsg.h"
#import "MKSell.h"
#import "MKSellDeliveryAddress.h"
#import "MKPanelManager.h"

@implementation MKSellDelivery

- (id)init
{
    self = [super init];
    [self updateActions];
    [self addPropertyName:@"hasViewedAddress"];
    self.hasViewedAddress = [NSNumber numberWithBool:NO];
    return self;
}

- (void)updateActions
{
    {
        NavActionSlot *slot = [self.navMirror newActionSlotWithName:@"markAsPosted"];
        [slot setVisibleName:@"I've Sent Item"];
        [slot setIsActive:self.hasAddress && self.hasViewedAddress && !self.hasPosted];
        [slot setIsVisible:YES];
    }
    
    {
        NavActionSlot *slot = [self.navMirror newActionSlotWithName:@"viewAddress"];
        [slot setVisibleName:@"View Address"];
        [slot setIsActive:self.hasAddress];
        [slot setIsVisible:YES];
    }

}

- (MKSell *)sell
{
    return (MKSell *)self.nodeParent;
}

- (NSString *)nodeTitle
{
    return @"Dispatch";
}

- (BOOL)isComplete
{
    return self.hasAddress && self.hasPosted;
}

- (BOOL)isActive
{
    return self.sell.lockEscrow.isComplete && !self.isComplete;
}

- (NSString *)nodeSubtitle
{
    if (self.hasAddress)
    {
        if (self.hasPosted)
        {
            return @"Complete";
        }
        
        return @"Buyer escrow set up. Deliver item to buyer.";
    }
    
    return @"Awaiting delivery address from buyer.";
}

- (NSString *)nodeNote
{
    if (self.isComplete)
    {
        return @"✓";
    }

    if (self.sell.lockEscrow.isComplete)
    {
        return @"●";
    }
    
    return nil;
}

- (BOOL)handleMsg:(MKMsg *)msg
{
    if ([msg isKindOfClass:MKBuyerAddressMsg.class])
    {
        if([self addChild:msg])
        {
            MKBuyerAddressMsg *addressMsg = (MKBuyerAddressMsg *)msg;
            MKSellDeliveryAddress *address = [[MKSellDeliveryAddress alloc] init];
            address.addressDict = [NSMutableDictionary dictionaryWithDictionary:addressMsg.addressDict];
            [self addChild:address];
        }

        [self update];
        return YES;
    }
    
    return NO;
}

- (void)update
{
    [self updateActions];
}

// address


- (BOOL)hasAddress
{
    return self.address != nil;
}

- (MKSellDeliveryAddress *)address
{
    return [self.children firstObjectOfClass:MKSellDeliveryAddress.class];
}

// posting

- (void)markAsPosted
{
    if (!self.hasPosted)
    {
        [self addChild:[[MKSellPostedMsg alloc] init]];
    }
    
    [self postParentChainChanged];
}

- (BOOL)hasPosted
{
    return self.postedMsg != nil;
}

- (MKSellPostedMsg *)postedMsg
{
    return [self.children firstObjectOfClass:MKSellPostedMsg.class];
}

- (void)viewAddress // this shouldn't be at the model level
{
    MKPanelManager *panelManager = [MKPanelManager sharedPanelManager];
    MKPanelView *panel = [panelManager openNewPanel];
    
    [panel setInnerView:self.address.nodeView];
    [self.nodeView addSubview:panel];
    [panel layout];
    
    self.hasViewedAddress = [NSNumber numberWithBool:YES];
    [self updateActions];
}


@end
