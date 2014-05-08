//
//  MKBuyerPostLockEscrowMsg.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/7/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKBuyerPostLockEscrowMsg.h"
#import <BitnashKit/BitnashKit.h>
#import "MKRootNode.h"

@implementation MKBuyerPostLockEscrowMsg

- (NSString *)nodeTitle
{
    return @"Buyer Posted Escrow to Blockchain";
}

- (BNWallet *)wallet
{
    return MKRootNode.sharedMKRootNode.wallet;
}

- (void)setupFromSellerPayload:(NSString *)aPayload
{
    // aPayload contains the seller signed tx
    // we need to sign it and then post it
    
    NSString *completedTx = @"[completed tx]";
    
    [self setPayload:completedTx]; // store this for our records
}

- (BOOL)postToBlockchain
{
    [self addDate];
    
    // add code to post
    
    return NO;
}

- (BOOL)isConfirmed
{
    // add code to post
    
    return NO;
}

- (BOOL)isCancelled
{
    // add code to see if any utxs in the escrow were spent
    // outside of the escrow
    
    return NO;
}

@end
