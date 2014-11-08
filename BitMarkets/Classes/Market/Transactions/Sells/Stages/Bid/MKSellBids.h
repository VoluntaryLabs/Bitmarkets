//
//  MKSellBids.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKStage.h"
#import "MKSellBid.h"

@interface MKSellBids : MKStage

- (void)setAcceptedBid:(MKSellBid *)sellBid;

- (MKSellBid *)acceptedBid;
- (BOOL)isComplete;

- (void)sendClosePost;
- (void)rejectUnacceptedBids;

@end
