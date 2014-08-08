//
//  MKStepsView.h
//  BitMarkets
//
//  Created by Steve Dekorte on 6/10/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MKNodeView.h"

@interface MKStepsView : MKNodeView

@property (assign, nonatomic) id delegate;

- (void)syncFromNode;

@end
