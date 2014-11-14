//
//  MKBuys.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/13/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <BitMessageKit/BitMessageKit.h>
#import "MKBuy.h"
#import "MKTransactions.h"

@interface MKBuys : MKTransactions

- (MKBuy *)addBuy;

@end
