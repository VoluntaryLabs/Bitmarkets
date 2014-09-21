//
//  MKMarkets.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/13/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKMarkets.h"
#import "MKExchangeRate.h"
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
    [self addChild:self.rootRegion];
    
    if (NO)
    {
        [_rootRegion setShouldInlineChildren:YES];
        _rootRegion.nodeSuggestedWidth = 600;
    }
    //[self setShouldInlineChildren:YES];
    
    self.mkChannel = [[MKMarketChannel alloc] init];
    [self addChild:self.mkChannel];

    self.buys  = [[MKBuys alloc] init];
    //[_buys read];
    [self addChild:_buys];

    self.sells = [[MKSells alloc] init];
    //[_sells read];
    [self addChild:_sells];
    
    [self.mkChannel performSelector:@selector(fetch) withObject:nil afterDelay:0.0];
    [self.rootRegion updateCounts];
    
    //[MKExchangeRate shared];

    [self setRefreshInterval:10];
    return self;
}

- (void)read
{
    [_buys  read];
    [_sells read];
}

- (void)write
{
    [_buys  write];
    [_sells write];
}

- (BOOL)handleMsg:(MKMsg *)msg
{
    if ([self.sells handleMsg:msg])
    {
        return YES;
    }
    
    if ([self.buys  handleMsg:msg])
    {
        return YES;
    }
    
    return NO;
}

- (void)refresh
{
    [self.sells update];
    [self.buys  update];
    [self.mkChannel fetch];
}


@end
