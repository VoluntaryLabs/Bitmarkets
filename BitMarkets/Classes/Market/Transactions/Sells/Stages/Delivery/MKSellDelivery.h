//
//  MKSellDelivery.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKStage.h"
#import "MKSellPostedMsg.h"

@interface MKSellDelivery : MKStage

- (BOOL)isComplete;

- (MKSellPostedMsg *)postedMsg;

@end
