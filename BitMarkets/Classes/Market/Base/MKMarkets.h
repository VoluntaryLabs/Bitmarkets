//
//  MKMarkets.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/13/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <BitMessageKit/BitMessageKit.h>

#import "MKMarketChannel.h"

#import "MKRegion.h"
#import "MKCategory.h"

#import "MKBuys.h"
#import "MKBuy.h"

#import "MKSells.h"
#import "MKSell.h"

@interface MKMarkets : NavInfoNode

@property (strong, nonatomic) MKRegion *rootRegion;

//@property (strong, nonatomic) MKCategory *rootCategory;
@property (strong, nonatomic) MKMarketChannel *mkChannel;

@property (strong, nonatomic) MKBuys *buys;
@property (strong, nonatomic) MKSells *sells;


- (void)read;
- (void)write;
- (BOOL)handleMsg:(MKMsg *)mkMsg;

@end
