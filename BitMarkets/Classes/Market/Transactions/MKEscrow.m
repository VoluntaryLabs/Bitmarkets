//
//  MKEscrow.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/13/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKEscrow.h"
#import "MKBuy.h"
#import "MKSell.h"

@implementation MKEscrow

- (MKBuy *)buy
{
    MKBuy *buy = (MKBuy *)[self firstInParentChainOfClass:MKBuy.class];
    assert(buy != nil);
    return buy;
}

- (MKSell *)sell
{
    MKSell *sell = (MKSell *)[self firstInParentChainOfClass:MKSell.class];
    assert(sell != nil);
    return sell;
}

- (NSString *)deleteWarning
{
    if (!self.isComplete)
    {
        return @"Escrow is incomplete. Deleting this transaction could result is lost funds. Please cancel escrow before deleting is possible.";
    }
    
    return nil;
}

@end
