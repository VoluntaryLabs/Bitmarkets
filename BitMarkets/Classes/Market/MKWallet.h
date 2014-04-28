//
//  MKWallet.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/13/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <BitMessageKit/BitMessageKit.h>
#import <BitnashKit/BitnashKit.h>
#import <NavKit/NavKit.h>

@interface MKWallet : NavNode

@property (strong, nonatomic) BNWallet *bnWallet;
@property (strong, nonatomic) NavInfoNode *balance;
@property (strong, nonatomic) NavInfoNode *transactions;


@end
