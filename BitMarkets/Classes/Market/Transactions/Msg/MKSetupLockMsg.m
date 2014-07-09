//
//  MKSetupLockMsg.m
//  BitMarkets
//
//  Created by Rich Collins on 7/8/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKSetupLockMsg.h"
#import "MKLock.h"

@implementation MKSetupLockMsg

- (void)configureAndBroadcastTx
{
    BNTx *escrowTx = [self.runningWallet newTx];
    [escrowTx configureForEscrowWithValue:self.lockNode.lockEscrowPriceInSatoshi];
    self.lockNode.error = nil;
    if (escrowTx.error)
    {
        if (escrowTx.error.insufficientValue)
        {
            self.lockNode.error = [NSString stringWithFormat:@"%@BTC Required", escrowTx.error.insufficientValue.satoshiToBtc];
        }
        else
        {
            [NSException raise:@"tx configureForOutputWithValue failed" format:nil];
        }
        
        return;
    }
    
    NSNumber *value = [NSNumber numberWithLongLong:
                       [(BNTxOut *)[escrowTx.outputs firstObject] value].longLongValue + [escrowTx fee].longLongValue];
    
    self.tx = [self.runningWallet newTx];
    [self.tx configureForOutputWithValue:value];
    [self.tx subtractFee];
    [self.tx sign];
    [self.tx broadcast]; //TODO make sure that peers accepted it
    self.payload = self.tx.asJSONObject;
}

@end
