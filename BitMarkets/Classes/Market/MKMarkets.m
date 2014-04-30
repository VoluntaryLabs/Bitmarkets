//
//  MKMarkets.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/13/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKMarkets.h"
#import <BitMessageKit/BitMessageKit.h>
#import <NavKit/NavKit.h>

@implementation MKMarkets

- (id)init
{
    self = [super init];
    self.nodeTitle = @"BitMarkets";
    self.nodeSuggestedWidth = 150;
    
    self.shouldSortChildren = NO;
    
    _rootRegion = (MKRegion *)[MKRegion rootInstance];
    [self.children addObject:self.rootRegion];
    
    if (NO)
    {
        [_rootRegion setShouldInlineChildren:YES];
        _rootRegion.nodeSuggestedWidth = 600;
    }
    //[self setShouldInlineChildren:YES];
    
    self.mkChannel = [[MKMarketChannel alloc] init];
    [self addChild:self.mkChannel];

    self.buys  = [[MKBuys alloc] init];
    [self addChild:self.buys];

    self.sells = [[MKSells alloc] init];
    [self addChild:self.sells];
    
    [self.mkChannel performSelector:@selector(fetch) withObject:nil afterDelay:0.0];
    [self.rootRegion updateCounts];
    
    [MKExchangeRate shared];


    return self;
}

@end
