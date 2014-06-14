//
//  MKBuyBid.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKStage.h"
#import "MKBidMsg.h"
#import "MKAcceptBidMsg.h"
#import "MKRejectBidMsg.h"

@interface MKBuyBid : MKStage

- (MKBidMsg *)bidMsg;
- (MKAcceptBidMsg *)acceptMsg;
- (MKRejectBidMsg *)rejectMsg;

- (BOOL)wasSent;
- (BOOL)wasAccepted;
- (BOOL)wasRejected;

@end
