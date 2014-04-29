//
//  MKWallet.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/13/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKWallet.h"
#import <NavKit/NavKit.h>

@implementation MKWallet

- (id)init
{
    self = [super init];
    
    _bnWallet = [[BNWallet alloc] init];
    _bnWallet.server.logsStderr = YES;
    
    self.nodeTitle = @"Wallet";

    {
        _balance = [[NavInfoNode alloc] init];
        [self addChild:_balance];
        _balance.nodeTitle = @"Balance";
        _balance.nodeSubtitle = @"(unavailable)";
        _balance.nodeSuggestedWidth = 200;
    }
    
    {
        _transactions = [[NavInfoNode alloc] init];
        //[self addChild:_transactions];
        _transactions.nodeTitle = @"Transactions";
        _transactions.nodeSubtitle =  @"(unavailable)";
        //transactions.nodeNote =  @"0";
        _transactions.nodeSuggestedWidth = 200;
    }

    [self performSelector:@selector(startWallet) withObject:nil afterDelay:0.0];
    return self;
}

- (void)startWallet
{
    [_bnWallet.server start];
    [self update];
    //[self performSelector:@selector(startWallet) withObject:nil afterDelay:0.0];
}

- (void)update
{
    NSString *status = _bnWallet.server.status;
    BOOL isStarted = [status isEqualToString:@"started"];
    
    NSString *balanceSubtitle = nil;
    
    if (isStarted)
    {
        float balanceValue = self.bnWallet.balance.floatValue;
        balanceSubtitle = [NSString stringWithFormat:@"%.4f BTC", balanceValue];
    }
    else
    {
        balanceSubtitle = @"starting...";
    }

    _balance.nodeSubtitle = balanceSubtitle;
    [_balance postParentChanged];
    
    self.nodeSubtitle = balanceSubtitle;
    [self postParentChanged];

    [self performSelector:@selector(update) withObject:nil afterDelay:5.0];
}


@end
