//
//  MKSells.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/13/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <BitmessageKit/BMNode.h>
#import "MKSell.h"
#import "MKTransactions.h"

@interface MKSells : MKTransactions

- (MKSell *)addSell;

@end
