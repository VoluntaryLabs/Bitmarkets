//
//  MKTransactions.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/12/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKGroup.h"
#import "MKTransaction.h"
#import "MKMsg.h"

@interface MKTransactions : MKGroup

- (BOOL)handleMsg:(MKMsg *)msg;
- (void)update;

@end
