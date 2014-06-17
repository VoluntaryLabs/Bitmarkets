//
//  MKBuyLockEscrow.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKLock.h"
#import <BitnashKit/BitnashKit.h>

@interface MKBuyLockEscrow : MKLock

@property (strong, nonatomic) NSTimer *confirmTimer;
@property (strong, nonatomic) BNTx *escrowInputTx;

- (void)update;
- (BOOL)isConfirmed;
- (BOOL)isComplete;

@end
