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
    // do this so we only generate it if it isn't set
    // which it would be if we unpersisted it
    
    /*
    if ([super nodeTitle] == nil)
    {
        self.address = self.wallet.bnWallet.createAddress;
        self.nodeTitle = self.address;
    }
    */
    
    return self.address;
//    return [[self.address substringToIndex:12] stringByAppendingString:@"..."];
}

- (MKWallet *)wallet
{
    return MKRootNode.sharedMKRootNode.wallet;
}

@end
