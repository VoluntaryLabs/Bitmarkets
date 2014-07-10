//
//  MKBuyLockEscrowMSg.m
//  BitMarkets
//
//  Created by Rich Collins on 7/8/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKBuyLockEscrowMsg.h"
#import "MKBuyLockEscrow.h"

@implementation MKBuyLockEscrowMsg

- (MKBuyLockEscrow *)buyLockEscrow
{
    return (MKBuyLockEscrow *)[self lockNode];
}

- (void)configureTx
{
    self.tx = [self.runningWallet newTx];
    
    [self.tx configureForEscrowWithInputTx:self.lockNode.setupLockMsg.tx];
    self.tx = [self.buyLockEscrow.sellLockEscrowMsg.tx mergedWithEscrowTx:self.tx];
    [self.tx subtractFee];
    
    @try
    {
        [self.tx sign];
    }
    @catch (NSException *exception)
    {
        self.lockNode.error = @"escrow sign error";
    }
    
    [self.tx lockInputs];
}

- (void)broadcast
{
    @try
    {
        self.lockNode.error = nil;
        [self.tx sign]; //TODO verify tx meets expectations before signing
        [self.tx broadcast];
    }
    @catch (NSException *exception)
    {
        self.lockNode.error = @"escrow sign error";
    }

}

@end
