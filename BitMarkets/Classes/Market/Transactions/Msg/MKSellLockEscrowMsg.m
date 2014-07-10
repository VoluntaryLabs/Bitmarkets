//
//  MKLockEscrowMsg.m
//  BitMarkets
//
//  Created by Rich Collins on 7/8/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKSellLockEscrowMsg.h"
#import "MKLock.h"

@implementation MKSellLockEscrowMsg

- (void)configureTx
{
    self.tx = [self.runningWallet newTx];
    [self.tx configureForEscrowWithInputTx:self.lockNode.setupLockMsg.tx];
    [self.tx lockInputs];
}

@end
