//
//  MKStepsView.m
//  BitMarkets
//
//  Created by Steve Dekorte on 6/10/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKStepsView.h"
#import "MKStepView.h"

@implementation MKStepsView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [NSColor blueColor];
    }
    
    return self;
}

- (void)setNode:(NavNode *)node
{
    _node = node;
    
    [self removeAllSubviews];
    
    for (NavNode *subnode in _node.children)
    {
        MKStepView *stepView = [[MKStepView alloc] init];
        [stepView setNode:subnode];
        [self addSubview:stepView];
    }
    
    //[self syncFromNode];
}


/*
- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
}
*/

@end
