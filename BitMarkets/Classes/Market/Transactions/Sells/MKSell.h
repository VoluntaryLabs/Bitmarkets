//
//  MKSell.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <BitMessageKit/BitMessageKit.h>
#import "MKTransaction.h"
#import "MKPost.h"
#import "MKSellBids.h"
#import "MKSellLockEscrow.h"
#import "MKSellDelivery.h"
#import "MKSellReleaseEscrow.h"

@interface MKSell : MKTransaction

@property (strong, nonatomic) MKPost *mkPost;
@property (strong, nonatomic) MKSellBids *bids;
@property (strong, nonatomic) MKSellLockEscrow *lockEscrow;
@property (strong, nonatomic) MKSellDelivery *delivery;
@property (strong, nonatomic) MKSellReleaseEscrow *releaseEscrow;

@end
