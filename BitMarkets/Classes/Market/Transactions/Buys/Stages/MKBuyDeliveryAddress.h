//
//  MKBuyDeliveryAddress.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/7/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKGroup.h"
#import "MKBuyerAddressMsg.h"

@interface MKBuyDeliveryAddress : MKGroup

@property (strong, nonatomic) NSMutableDictionary *addressDict;

- (BOOL)isInBuy;
- (BOOL)isFilled;
- (BOOL)canSend;
- (void)sendMsg;

@end
