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

- (void)lookForConfirm
{
    if (!self.confirmMsg)
    {
        if (self.checkForConfirm)
        {
            MKConfirmLockEscrowMsg *msg = [[MKConfirmLockEscrowMsg alloc] init];
            [msg copyFrom:self.bidMsg];
            [self addChild:msg];
            [self stopConfirmTimer];
        }
    }
}

- (BOOL)shouldLookForConfirm
{
    [NSException raise:@"subclasses should override" format:nil];
    //return (self.buyerPostLockMsg && !self.confirmMsg);
    return NO;
}

// confirm timer

- (void)startConfirmTimerIfNeeded
{
    if (self.shouldLookForConfirm && !self.confirmTimer)
    {
        [self.confirmTimer invalidate];
        self.confirmTimer = [NSTimer scheduledTimerWithTimeInterval:self.refreshInterval
                                                             target:self
                                                           selector:@selector(lookForConfirm)
                                                           userInfo:nil
                                                            repeats:YES];
    }
}

- (void)stopConfirmTimer
{
    [self.confirmTimer invalidate];
    self.confirmTimer = nil;
}

@end
