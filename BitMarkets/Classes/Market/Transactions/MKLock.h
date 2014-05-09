//
//  MKLock.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/8/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKGroup.h"
#import "MKConfirmLockEscrowMsg.h"
#import "MKBidMsg.h"

@interface MKLock : MKGroup

@property (strong, nonatomic) NSTimer *confirmTimer;

- (MKConfirmLockEscrowMsg *)confirmMsg;

// conifrm

- (NSDictionary *)payloadToConfirm; // subclasses should override
- (BOOL)checkForConfirm; // subclasses should override
- (BOOL)shouldLookForConfirm; // subclasses should override

// confirm timer

- (void)startConfirmTimerIfNeeded;
- (void)stopConfirmTimer;

@end
