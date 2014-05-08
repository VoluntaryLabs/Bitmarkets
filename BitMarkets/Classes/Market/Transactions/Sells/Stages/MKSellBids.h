//
//  MKSellBids.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKGroup.h"
#import "MKSellBid.h"

@interface MKSellBids : MKGroup

- (void)setAcceptedBid:(MKSellBid *)sellBid;

- (MKSellBid *)acceptedBid;

@end
