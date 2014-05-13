//
//  MKRelease.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/13/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKGroup.h"

@class MKSell;
@class MKBuy;

// payment

#import "MKBuyPaymentMsg.h"
#import "MKSellAcceptPaymentMsg.h"

// refund

#import "MKBuyRefundRequestMsg.h"
#import "MKSellAcceptRefundRequestMsg.h"

// confirm

#import "MKConfirmRefundMsg.h"
#import "MKConfirmPaymentMsg.h"

@interface MKRelease : MKGroup

- (MKSell *)sell;
- (MKBuy *)buy;

// payment

- (MKBuyPaymentMsg *)buyPaymentMsg;
- (MKSellAcceptPaymentMsg *)sellAcceptPaymentMsg;

// refund messages

- (MKBuyRefundRequestMsg *)buyRequestRefundMsg;
- (MKSellAcceptRefundRequestMsg *)sellAcceptRefundRequestMsg;

// confirm

- (MKConfirmRefundMsg *)confirmRefundMsg;
- (MKConfirmPaymentMsg *)confirmPaymentMsg;

@end
