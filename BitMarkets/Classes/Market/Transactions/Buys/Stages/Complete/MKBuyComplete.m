//
//  MKBuyComplete.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKBuyComplete.h"
#import "MKBuy.h"

@implementation MKBuyComplete

- (id)init
{
    self = [super init];
    
    return self;
}

// node

- (CGFloat)nodeSuggestedWidth
{
    return 300;
}

- (NSString *)nodeTitle
{
    return @"Complete";
}

- (MKBuy *)buy
{
    return (MKBuy *)self.nodeParent;
}

- (NSString *)nodeSubtitle
{
    /*
    if (self.buy.releaseEscrow.wasPaid)
    {
        return @"Complete! Payment made to seller & deposit returned";
    }
    
    if (self.buy.releaseEscrow.wasRefunded)
    {
        return @"Complete! Payment refunded by seller & deposit returned";
    }
    */
    
   return self.buy.releaseEscrow.nodeSubtitle;
}

- (NSString *)nodeNote
{
    if (self.isComplete)
    {
        return @"✓";
    }
    
    return nil;
}

- (BOOL)isComplete
{
    return self.buy.releaseEscrow.isComplete;
}

@end
