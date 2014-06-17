//
//  MKNodeView.h
//  BitMarkets
//
//  Created by Steve Dekorte on 6/16/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <NavKit/NavKit.h>

@interface MKNodeView : NavColoredView

@property (assign, nonatomic) NavNode *node;

- (void)layout; // subclasses should override
- (void)syncFromNode; // subclasses should override

@end
