//
//  MKLockEscrowSetupMsgDelegate.h
//  BitMarkets
//
//  Created by Rich Collins on 7/4/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MKLockEscrowSetupMsgDelegate

- (BNWallet *)runningWallet;
- (NSNumber *)lockEscrowPriceInSatoshi;
- (void)setError:(NSString *)error;
- (void)useEscrowTx:(BNTx *)escrowTx;

@end
