//
//  MKSellBid.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKGroup.h"
#import "MKBidMsg.h"
#import <BitnashKit/BitnashKit.h>

@interface MKSellBid : MKGroup

@property (strong, nonatomic) BNTx *escrowInputTx;

- (MKBidMsg *)bidMsg;

- (BOOL)wasAccepted;
- (BOOL)wasRejected;


- (void)reject;

@end
