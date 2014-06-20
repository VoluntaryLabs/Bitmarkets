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


- (NSString *)shortStatus;

// checks

- (BOOL)wasPaid;
- (BOOL)wasRefunded;

// payment messages

- (MKBuyPaymentMsg *)buyPaymentMsg;
- (MKSellAcceptPaymentMsg *)sellAcceptPaymentMsg;

// refund messages

- (MKBuyRefundRequestMsg *)buyRequestRefundMsg;
- (MKSellAcceptRefundRequestMsg *)sellAcceptRefundRequestMsg;
- (MKSellRejectRefundRequestMsg *)sellRejectRefundRequestMsg;

// confirm messages

- (MKConfirmRefundMsg *)confirmRefundMsg;
- (MKConfirmPaymentMsg *)confirmPaymentMsg;

// confirm checks

- (void)lookForConfirmsIfNeeded;
- (void)lookForPaymentConfirmIfNeeded;
- (void)lookForRefundConfirmIfNeeded;

@end
