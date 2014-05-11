//
//  MKLock.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/8/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKLock.h"
#import "MKConfirmLockEscrowMsg.h"
#import <BitnashKit/BitnashKit.h>

@implementation MKLock

- (MKConfirmLockEscrowMsg *)confirmMsg
{
    return [self.children firstObjectOfClass:MKConfirmLockEscrowMsg.class];
}


- (BOOL)isConfirmed
{
    return self.confirmMsg != nil;
}

// confirm

- (NSDictionary *)payloadToConfirm
{
    [NSException raise:@"subclasses should override" format:nil];
    return nil;
}

- (BOOL)checkForConfirm
{
    BNTx *tx = (BNTx *)[self.payloadToConfirm asObjectFromJSONObject];
    
    if ([tx isConfirmed]) //TODO instead check to see if outputs are spent in case tx is mutated
    {
        return YES;
    }

    return NO;
}

- (MKBidMsg *)bidMsg
{
    [NSException raise:@"subclasses should override" format:nil];
    return nil;
}

- (void)lookForConfirmIfNeeded
{
    if (self.shouldLookForConfirm)
    {
        if (self.checkForConfirm)
        {
            MKConfirmLockEscrowMsg *msg = [[MKConfirmLockEscrowMsg alloc] init];
            [msg copyFrom:self.bidMsg];
            [self addChild:msg];
        }
    }
}

- (BOOL)shouldLookForConfirm
{
    [NSException raise:@"subclasses should override" format:nil];
    //return (self.buyerPostLockMsg && !self.confirmMsg);
    return NO;
}


@end
