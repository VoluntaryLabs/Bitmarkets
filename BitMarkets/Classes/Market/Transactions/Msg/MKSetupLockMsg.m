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

- (id)init
{
    self = [super init];
    [self addPropertyName:@"broadcastDateNumber"];
    return self;
}

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
            self.lockNode.error = @"unknown error while constructing change tx";
        }
        
        return;
    }
    
    NSNumber *value = [NSNumber numberWithLongLong:
                       [(BNTxOut *)[escrowTx.outputs firstObject] value].longLongValue + [escrowTx fee].longLongValue];
    
    self.tx = [self.runningWallet newTx];
    [self.tx configureForOutputWithValue:value];
    [self.tx subtractFee];
    [self.tx sign];
    [self.tx lockOutput:[self.tx firstOutput]];
    self.payload = self.tx.asJSONObject;
    [self write];
    [self.tx broadcast]; //TODO make sure that peers accepted it
    //[self broadcastIfNeeded];
}

- (void)returnChangeToWallet
{
    if (self.tx)
    {
        [self.tx unlockOutputs];
    }
}
/*
- (void)broadcastIfNeeded
{
    NSTimeInterval broadcastTimeoutInSeconds = 20*60;
    
    if (self.tx && !self.tx.isConfirmed)
    {
        if (
                !self.broadcastDate ||
                ([self.broadcastDate ageInSeconds] > broadcastTimeoutInSeconds)
            )
        {
            @try
            {
                [self.tx broadcast]; //TODO make sure that peers accepted it

                NSLog(@"MKSetupLockMsg broadcast change tx '%@'", self.tx.txHash);
                [self setBroadcastDate:[NSDate date]];
                [self write];
            }
            @catch (NSException *exception)
            {
                [self lockNode].error = [exception description];
                NSLog(@"MKSetupLockMsg broadcast error '%@'",[exception description]);
            }
        }
    }
}
 */

- (void)setBroadcastDate:(NSDate *)aDate
{
    self.broadcastDateNumber = [aDate asNumber];
}

- (NSDate *)broadcastDate
{
    return [NSDate fromNumber:self.broadcastDateNumber];
}

@end
