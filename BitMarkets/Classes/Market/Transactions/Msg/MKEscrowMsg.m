//
//  MKEscrowMsg.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/7/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKEscrowMsg.h"
#import "MKBuyLockEscrow.h"
#import <BitnashKit/BitnashKit.h>

@implementation MKEscrowMsg

- (id)init
{
    self = [super init];
    [self.dictPropertyNames addObject:@"payload"];
    return self;
}

- (void)setPayload:(NSDictionary *)payload
{
    [self.dict setObject:payload forKey:@"payload"];
}

- (NSDictionary *)payload
{
    return [self.dict objectForKey:@"payload"];
}

- (NSArray *)modelActions
{
    return @[@"delete"];
}

- (BOOL)isPayloadConfirmed
{
    BNWallet *wallet = self.runningWallet;
    
    if (!wallet)
    {
        return NO;
    }
    
    BNTx *tx = (BNTx *)[self.payload asObjectFromJSONObject];
    tx.wallet = wallet;
    [tx refresh];
    
    if ([tx isConfirmed]) // TODO instead check to see if outputs are spent in case tx is mutated
    {
        return YES;
    }
    
    return NO;
}

@end
