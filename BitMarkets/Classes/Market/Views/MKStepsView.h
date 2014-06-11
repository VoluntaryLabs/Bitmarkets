//
//  MKStepsView.h
//  BitMarkets
//
//  Created by Steve Dekorte on 6/10/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MKTransaction.h"

@interface MKStepsView : NSView

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) MKTransaction *transaction;

@end
