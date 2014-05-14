//
//  MKRelease.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/13/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKEscrow.h"

@class MKSell;
@class MKBuy;

// payment

#import "MKBuyPaymentMsg.h"
#import "MKSellAcceptPaymentMsg.h"

// refund

#import "MKBuyRefundRequestMsg.h"
#import "MKSellAcceptRefundRequestMsg.h"
#import "MKSellRejectRefundRequestMsg.h"

// confirm

#import "MKConfirmRefundMsg.h"
#import "MKConfirmPaymentMsg.h"



@interface MKRelease : MKEscrow


// payment

- (MKBuyPaymentMsg *)buyPaymentMsg;
- (MKSellAcceptPaymentMsg *)sellAcceptPaymentMsg;

// refund messages

- (MKBuyRefundRequestMsg *)buyRequestRefundMsg;
- (MKSellAcceptRefundRequestMsg *)sellAcceptRefundRequestMsg;
- (MKSellRejectRefundRequestMsg *)sellRejectRefundRequestMsg;

// confirm

- (MKConfirmRefundMsg *)confirmRefundMsg;
- (MKConfirmPaymentMsg *)confirmPaymentMsg;

@end
