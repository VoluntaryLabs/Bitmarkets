//
//  MKBuyLockEscrow.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKLock.h"

@interface MKBuyLockEscrow : MKLock

@property (strong, nonatomic) NSTimer *confirmTimer;

- (void)update;
- (BOOL)isConfirmed;

@end
