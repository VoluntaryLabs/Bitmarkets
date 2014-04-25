//
//  MKWallet.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/13/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <BitMessageKit/BitMessageKit.h>
#import <BitnashKit/BitnashKit.h>

@interface MKWallet : NavNode

@property (strong, nonatomic) BNWallet *bnWallet;


@end
