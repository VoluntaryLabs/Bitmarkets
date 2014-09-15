//
//  MKCancelMsg.m
//  BitMarkets
//
//  Created by Steve Dekorte on 6/10/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKCancelMsg.h"
#import "MKLock.h"

@implementation MKCancelMsg

- (void)configureTx
{
    if (self.lockNode.lockEscrowMsgToConfirm)
    {
        self.tx = self.lockNode.lockEscrowMsgToConfirm.tx.cancellationTx;
        [self.tx unlockInputs];
        [self.tx sign];
    }
    else
    {
        self.tx = nil;
    }
    
}

- (void)broadcast
{
    if (self.tx)
    {
        self.payload = self.tx.asJSONObject;
        [self write];
        [self.tx broadcast];
    }
}

@end
