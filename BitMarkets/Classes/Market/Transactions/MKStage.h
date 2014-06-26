//
//  MKStage.h
//  BitMarkets
//
//  Created by Steve Dekorte on 6/13/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKGroup.h"

@class MKTransaction;

@interface MKStage : MKGroup

- (BOOL)isActive;
- (BOOL)isComplete;

- (MKTransaction *)transaction;

- (MKStage *)nextStage;
- (MKStage *)previousStage;

@end
