//
//  MKBuys.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/13/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <BitMessageKit/BitMessageKit.h>
#import "MKBuy.h"
#import "MKGroup.h"

@interface MKBuys : MKGroup

- (MKBuy *)addBuy;
- (BOOL)handleMsg:(MKMsg *)mkMsg;
- (void)update;

@end
