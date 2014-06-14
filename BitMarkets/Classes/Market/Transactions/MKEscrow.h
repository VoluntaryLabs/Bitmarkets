//
//  MKEscrow.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/13/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKStage.h"
#import "MKCancelMsg.h"
#import "MKCancelConfirmed.h"

@class MKBuy;
@class MKSell;

@interface MKEscrow : MKStage

@property (strong, nonatomic) NSString *error;

- (MKSell *)sell;
- (MKBuy *)buy;


@end
