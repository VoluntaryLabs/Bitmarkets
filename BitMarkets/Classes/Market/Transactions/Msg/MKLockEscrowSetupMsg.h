//
//  MKLockEscrowInputMsg.h
//  BitMarkets
//
//  Created by Rich Collins on 6/19/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKMsg.h"
#import "MKLockEscrowSetupMsgDelegate.h"

@interface MKLockEscrowSetupMsg : MKMsg

@property (nonatomic) BNTx *escrowInputTx;

@property (weak) id <MKLockEscrowSetupMsgDelegate> delegate;

- (void)update;

@end
