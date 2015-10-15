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

// buy

- (MKBuy *)buy
{
    MKBuy *buy = (MKBuy *)[self firstInParentChainOfClass:MKBuy.class];
    assert(buy != nil);
    return buy;
}

- (BOOL)isBuy
{
    return self.buy != nil;
}

// sell

- (MKSell *)sell
{
    MKSell *sell = (MKSell *)[self firstInParentChainOfClass:MKSell.class];
    assert(sell != nil);
    return sell;
}

- (BOOL)isSell
{
    return self.sell != nil;
}


- (BOOL)isCancelConfirmed
{
    [NSException raise:@"MKEscrow subclasses should override isCancelled method" format:@""];
    return NO;
}



@end
