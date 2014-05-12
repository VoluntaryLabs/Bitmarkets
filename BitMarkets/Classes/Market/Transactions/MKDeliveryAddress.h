//
//  MKDeliveryAddress.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/7/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKGroup.h"
#import "MKBuyerAddressMsg.h"

@interface MKDeliveryAddress : MKGroup

@property (strong, nonatomic) NSMutableDictionary *addressDict;
@property (assign, nonatomic) BOOL isEditable;

- (BOOL)isFilled;
- (BOOL)canSend;

@end
