//
//  MKWalletAddress.m
//  BitMarkets
//
//  Created by Steve Dekorte on 4/29/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKWalletAddress.h"
#import "MKRootNode.h"

@implementation MKWalletAddress

- (id)init
{
    self = [super init];
    //self.nodeSubtitle = @"balance unknown";
    return self;
}

- (NSString *)nodeTitle
{
    return self.address;
}

- (void)generate
{
    self.address = self.wallet.bnWallet.createAddress;
}


- (MKWallet *)wallet
{
    return MKRootNode.sharedMKRootNode.wallet;
}

@end
