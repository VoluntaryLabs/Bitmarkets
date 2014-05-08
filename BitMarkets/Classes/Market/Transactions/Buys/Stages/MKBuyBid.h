//
//  MKBuyBid.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKGroup.h"
#import "MKBidMsg.h"

@interface MKBuyBid : MKGroup

- (MKBidMsg *)bidMsg;
- (MKBidMsg *)acceptMsg;
- (MKBidMsg *)rejectMsg;

- (BOOL)wasSent;
- (BOOL)wasAccepted;
- (BOOL)wasRejected;

@end
