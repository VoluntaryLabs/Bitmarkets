//
//  MKBuyDeliveryAddress.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/7/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKDeliveryAddress.h"
#import "MKBuyerAddressMsg.h"

@interface MKBuyDeliveryAddress : MKDeliveryAddress

- (void)approve;
- (BOOL)isApproved;

@end
