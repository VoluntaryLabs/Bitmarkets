//
//  MKBuyLockEscrow.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKLock.h"
#import "MKLockEscrowSetupMsgDelegate.h"
#import <BitnashKit/BitnashKit.h>

@interface MKBuyLockEscrow : MKLock <MKLockEscrowSetupMsgDelegate>

@property (strong, nonatomic) NSTimer *confirmTimer;

- (void)update;
- (BOOL)isConfirmed;
- (BOOL)isComplete;

@end
