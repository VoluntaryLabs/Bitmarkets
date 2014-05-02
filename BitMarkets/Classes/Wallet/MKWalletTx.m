//
//  MKWalletTx.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/1/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKWalletTx.h"

@implementation MKWalletTx

/*
operty NSMutableArray *inputs;
@property NSMutableArray *outputs;

@property NSString *hash;

@property NSNumber *netValue;
@property NSNumber *updateTime;
@property NSString *counterParty
*/

- (NSString *)txTypeString
{
    if (self.bnTx.netValue > 0)
    {
        return @"deposit";
    }
    
    return @"withdraw";
}

- (NSString *)nodeTitle
{
    return self.bnTx.hash;
    //return [NSString stringWithFormat:@"%@", self.txTypeString];
}

- (NSString *)nodeNote
{
    return nil;
    //return [NSString stringWithFormat:@"%@...", [self.bnTx.hash substringToIndex:8]];
}

- (NSString *)nodeSubtitle
{
    return [NSString stringWithFormat:@"%.4f BTC", (float)(self.bnTx.netValue.doubleValue * 0.00000001)];
}

@end
