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
    
    self.shouldSortChildren = NO;
    
    _rootRegion = (MKRegion *)[MKRegion rootInstance];
    [_rootRegion setName:@"Regions"];
    [self.children addObject:self.rootRegion];
    [_rootRegion updateCounts]; // do this after refresh
    //[_rootRegion setShouldInlineChildren:YES];
    //[self setShouldInlineChildren:YES];
    
    /*
    self.rootCategory = (MKCategory *)[MKCategory rootInstance];
    [self.rootCategory setName:@"For Sale"];
    [self.rootCategory setCanPost:NO];
    [self.children addObject:self.rootCategory];
    */
    
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

- (NSString *)nodeTitle
{
    return @"BitMarkets";
}

- (CGFloat)nodeSuggestedWidth
{
    return 150;
}

@end
