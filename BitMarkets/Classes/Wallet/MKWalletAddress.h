//
//  MKWalletAddress.h
//  BitMarkets
//
//  Created by Steve Dekorte on 4/29/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <NavKit/NavKit.h>
#import <BitnashKit/BitnashKit.h>

@interface MKWalletAddress : NavInfoNode

@property (strong, nonatomic) BNKey *bnKey;

- (void)generate;

@end
