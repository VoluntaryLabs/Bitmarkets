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
    
    {
        _balance = [[NavInfoNode alloc] init];
        [self addChild:_balance];
        _balance.nodeTitle = @"Balance";
        _balance.nodeSubtitle = @"(unavailable)";
        _balance.nodeSuggestedWidth = 200;
    }
    
    {
        _transactions = [[NavInfoNode alloc] init];
        [self addChild:_transactions];
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
}

- (void)update
{
    if ([_bnWallet.server.status isEqualToString:@"started"])
    {
        _balance.nodeSubtitle = [NSString stringWithFormat:@"%.4f", self.bnWallet.balance.floatValue];
    }
    else
    {
        _balance.nodeSubtitle = @"(waiting for server)";
    }
}

- (NSString *)nodeTitle
{
    return @"Wallet";
}

- (NSString *)nodeSubtitle
{
    /*
    if (self.bnWallet)
    {
        float btc = self.bnWallet.balance.longLongValue / 100000000;
        return [NSString stringWithFormat:@"balance: %.4f BTC", (float)btc];
    }
   */
    
    return nil;
}


@end
