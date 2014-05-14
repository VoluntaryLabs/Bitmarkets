//
//  MKEscrow.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/13/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKGroup.h"

@class MKBuy;
@class MKSell;

@interface MKEscrow : MKGroup

- (MKSell *)sell;
- (MKBuy *)buy;

@end
