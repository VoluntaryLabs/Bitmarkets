//
//  MKLockEscrowInputMsg.m
//  BitMarkets
//
//  Created by Rich Collins on 6/19/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKLockEscrowSetupMsg.h"

@implementation MKLockEscrowSetupMsg

@synthesize escrowInputTx = _escrowInputTx;

- (BNTx *)escrowInputTx
{
    if (!_escrowInputTx)
    {
        _escrowInputTx = self.payload.asObjectFromJSONObject;
        _escrowInputTx.wallet = self.delegate.runningWallet;
    }
    return _escrowInputTx;
}

- (void)update
{
    BNWallet *wallet = [self.delegate runningWallet];
    
    if (!wallet)
    {
        return;
    }
    
    BNTx *escrowTx = [wallet newTx];
    
    if (self.escrowInputTx)
    {
        [self.escrowInputTx fetch];
        if (self.escrowInputTx.isConfirmed)
        {
            [escrowTx configureForEscrowWithInputTx:self.escrowInputTx];
        }
        else
        {
            return;
        }
    }
    else
    {
        [escrowTx configureForEscrowWithValue:self.delegate.lockEscrowPriceInSatoshi];
    }
    
    [self.delegate setError:nil];
    if (escrowTx.error)
    {
        NSLog(@"tx configureForOutputWithValue failed: %@", escrowTx.error.description);
        
        if (escrowTx.error.insufficientValue)
        {
            [self.delegate setError:[NSString stringWithFormat:@"%@BTC Required", escrowTx.error.insufficientValue.satoshiToBtc]];
        }
        else
        {
            [NSException raise:@"tx configureForOutputWithValue failed" format:nil];
            //TODO: handle unknown tx configureForEscrowWithValue error
        }
        
        return;
    }
    
    [escrowTx subtractFee];
    
    if ([escrowTx changeValue].longLongValue > 10000)
    {
        //create an output that won't lock up more than needed
        self.escrowInputTx = [wallet newTx];
        [self.escrowInputTx configureForOutputWithValue:[NSNumber numberWithLongLong:
                                                    [(BNTxOut *)[escrowTx.outputs firstObject] value].longLongValue + [escrowTx fee].longLongValue]];
        [self.escrowInputTx subtractFee];
        [self.escrowInputTx sign];
        [self.escrowInputTx broadcast]; //TODO make sure that peers accepted it
        self.payload = self.escrowInputTx.asJSONObject;
        return;
    }
    else
    {
        [escrowTx lockInputs];
        
        [self.delegate useEscrowTx:escrowTx];
    }
}

@end
