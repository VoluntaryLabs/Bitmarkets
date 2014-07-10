//
//  MKEscrowMsg.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/7/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKMsg.h"

@interface MKTxMsg : MKMsg

@property BNTx *tx;

- (void)configureTx;
- (BOOL)isTxConfirmed;

@end
