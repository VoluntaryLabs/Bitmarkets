//
//  MKStepView.h
//  BitMarkets
//
//  Created by Steve Dekorte on 6/12/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <NavKit/NavKit.h>

@interface MKStepView : NSView

@property (assign, nonatomic) NavNode *node; // transaction

@end
