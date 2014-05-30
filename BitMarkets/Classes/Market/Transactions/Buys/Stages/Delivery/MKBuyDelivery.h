//
//  MKBuyDelivery.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKGroup.h"
#import "MKBuyDeliveryAddress.h"
#import "MKBuyerAddressMsg.h"

@class MKBuy;

@interface MKBuyDelivery : MKGroup

- (MKBuyDeliveryAddress *)address;
- (MKBuyerAddressMsg *)addressMsg;
- (MKBuy *)buy;

- (void)update;
- (void)sendAddress;
- (BOOL)isApproved;

@end
