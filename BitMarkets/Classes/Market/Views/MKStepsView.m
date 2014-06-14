//
//  MKStepsView.m
//  BitMarkets
//
//  Created by Steve Dekorte on 6/10/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKStepsView.h"
#import "MKStepView.h"
#import "MKTransaction.h"

@implementation MKStepsView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [NSColor whiteColor];
    }
    
    return self;
}

- (MKTransaction *)transaction
{
    return (MKTransaction *)_node;
}


- (void)setNode:(NavNode *)node
{
    _node = node;
    
    [self removeAllSubviews];
    
    for (NavNode *subnode in self.transaction.visibleStages)
    {
        MKStepView *stepView = [[MKStepView alloc] initWithFrame:NSMakeRect(0, 0, 100, self.height)];
        [stepView setNode:subnode];
        [self addSubview:stepView];
    }
    
    [self layout];
    //[self syncFromNode];
}

- (void)setFrame:(NSRect)frameRect
{
    [super setFrame:frameRect];
    [self layout];
}

- (void)layout
{
    NSInteger count = self.transaction.visibleStages.count;
    
    for (MKStepView *stepView in self.subviews)
    {
        [stepView setWidth:self.width/count];
    }
    
    [self stackSubviewsLeftToRightWithMargin:0.0];
    
}


/*
- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
}
*/

@end
