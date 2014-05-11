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

- (MKConfirmLockEscrowMsg *)confirmMsg;
- (BOOL)isConfirmed;

// conifrm

- (void)lookForConfirmIfNeeded;
- (NSDictionary *)payloadToConfirm; // subclasses should override
- (BOOL)shouldLookForConfirm; // subclasses should override


@end
