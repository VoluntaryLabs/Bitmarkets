//
//  MKSellDelivery.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKSellComplete.h"
#import "MKSell.h"
#import "MKSellReleaseEscrow.h"

@implementation MKSellComplete

- (id)init
{
    self = [super init];
    return self;
}

- (MKSell *)sell
{
    return (MKSell *)self.nodeParent;
}

- (NSString *)nodeTitle
{
    return @"Complete";
}

- (BOOL)isActive
{
    return NO;
}

- (BOOL)isComplete
{
    return self.sell.releaseEscrow.isComplete;
}

- (NSString *)nodeSubtitle
{
    /*
    if (self.sell.releaseEscrow.wasPaid)
    {
        return @"Complete! Payment & deposit refund is in your wallet";
    }
    
    if (self.sell.releaseEscrow.wasRefunded)
    {
        return @"Complete! Payment refunded to buyer & your deposit is returned";
    }
    */
    
    return self.sell.releaseEscrow.nodeSubtitle;
}

- (NSString *)nodeNote
{
    if (self.isComplete)
    {
        return @"✓";
    }
    
    return nil;
}

- (void)update
{
    
}

@end
