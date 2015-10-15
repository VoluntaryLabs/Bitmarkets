//
//  MKEscrowMsg.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/7/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKTxMsg.h"
#import "MKBuyLockEscrow.h"
#import <BitnashKit/BitnashKit.h>

@implementation MKTxMsg

@synthesize tx = _tx;

- (BNTx *)tx
{
    if (!_tx && self.payload && self.runningWallet)
    {
        self.tx = (BNTx *)[self.payload asObjectFromJSONObject];
        self.tx.wallet = self.runningWallet;
    }
    
    return _tx;
}

- (void)setTx:(BNTx *)tx
{
    _tx = tx;
}


- (BOOL)isTxConfirmed
{
    if (self.tx)
    {
        [self.tx refresh];
        return self.tx.isConfirmed;
    }
    else
    {
        return NO;
    }
}

- (void)configureTx
{
    [NSException raise:@"Subclasses should override" format:@""];
}

@end
