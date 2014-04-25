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
    
    //self.bnWallet = [[BNWallet alloc] init];

    {
        NavInfoNode *balance = [[NavInfoNode alloc] init];
        [self addChild:balance];
        balance.nodeTitle = @"Balance";
        balance.nodeSubtitle = @"(unavailable)";
        balance.nodeSuggestedWidth = 200;
    }
    
    {
        NavInfoNode *transactions = [[NavInfoNode alloc] init];
        [self addChild:transactions];
        transactions.nodeTitle = @"Transactions";
        transactions.nodeSubtitle =  @"(unavailable)";
        //transactions.nodeNote =  @"0";
        transactions.nodeSuggestedWidth = 200;
    }

    return self;
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
