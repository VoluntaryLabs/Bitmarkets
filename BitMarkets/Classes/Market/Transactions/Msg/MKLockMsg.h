//
//  MKTxMsg.h
//  BitMarkets
//
//  Created by Rich Collins on 7/8/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKTxMsg.h"

@class MKLock;

@interface MKLockMsg : MKTxMsg

- (MKLock *)lockNode;

@end
