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
        [self verifyForBuyer];
        
        for (BNTxIn *txIn in self.tx.inputs)
        {
            //only sign inputs that I added
            if (![self.buyLockEscrow.sellLockEscrowMsg.tx.inputs containsObject:txIn])
            {
                [self.tx signInput:txIn];
                [self.tx lockInput:txIn];
            }
        }
    }
    @catch (NSException *exception)
    {
        self.lockNode.error = @"escrow sign error";
    }
}

- (void)verifyForBuyer
{
    BNTx *sellerTx = self.buyLockEscrow.sellLockEscrowMsg.tx;
    BNMultisigScriptPubKey *sellerScriptPubKey = (BNMultisigScriptPubKey *)sellerTx.firstOutput.scriptPubKey;
    
    assert(sellerTx.inputs.count == 1);
    
    assert(ABS(sellerTx.firstOutput.value.longLongValue - self.lockNode.mkPost.priceInSatoshi.longLongValue) < 20000); //TODO more precise check
    
    assert(sellerScriptPubKey.isMultisig);
}

- (void)broadcast //This is actually called by seller in MKSellLockEscrow broadcastLockIfNeeded
{
    @try
    {
        self.lockNode.error = nil;
        [self verifyForSeller];
        for (BNTxIn *txIn in self.tx.inputs)
        {
            //only sign inputs that I added
            if ([self.lockNode.sellLockEscrowMsg.tx.inputs containsObject:txIn])
            {
                [self.tx signInput:txIn];
                [self.tx lockInput:txIn];
            }
        }
        [self.tx broadcast];
    }
    @catch (NSException *exception)
    {
        self.lockNode.error = @"escrow sign error";
    }

}

- (void)verifyForSeller
{
    BNTx *sellerTx = self.lockNode.sellLockEscrowMsg.tx;
    BNMultisigScriptPubKey *sellerScriptPubKey = (BNMultisigScriptPubKey *)sellerTx.firstOutput.scriptPubKey;
    
    BNTx *buyerTx = self.tx;
    BNMultisigScriptPubKey *buyerScriptPubKey = (BNMultisigScriptPubKey *)buyerTx.firstOutput.scriptPubKey;
    
    assert(buyerTx.inputs.count == 2);
    assert([buyerTx.inputs containsObject:[sellerTx.inputs firstObject]]);
    
    //assert(buyerTx.foreignInputCount.intValue == 1); TODO: This won't work if you're buying from yourself :-/
    
    assert(ABS(buyerTx.firstOutput.value.longLongValue - 3*self.lockNode.mkPost.priceInSatoshi.longLongValue) < 20000); //TODO more precise check
    if (sellerTx.outputs.count > 1)
    {
        assert([buyerTx.outputs containsObject:[sellerTx.outputs objectAtIndex:1]]);
    }
    
    assert(buyerScriptPubKey.isMultisig);
    assert(buyerScriptPubKey.pubKeys.count == 2);
    assert([buyerScriptPubKey.pubKeys containsObject:[sellerScriptPubKey.pubKeys firstObject]]);
}

@end
