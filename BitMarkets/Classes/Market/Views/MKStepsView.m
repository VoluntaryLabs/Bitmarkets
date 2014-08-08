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
    return (MKTransaction *)self.node;
}

- (void)setNode:(NavNode *)node
{
    [super setNode:node];
    [self setupViews];
}

- (void)syncFromNode
{
    for (MKStepView *stepView in self.subviews)
    {
        [stepView syncFromNode];
    }
}

- (void)setupViews
{
    [self removeAllSubviews];
    MKStepView *stepView = nil;
    
    for (NavNode *subnode in self.transaction.visibleStages)
    {
        stepView = [[MKStepView alloc] initWithFrame:NSMakeRect(0, 0, 100, self.height)];
        [stepView setNode:subnode];
        [self addSubview:stepView];
        stepView.hasArrow = YES;
    }
    
    if (stepView)
    {
        stepView.hasArrow = NO;
    }
    
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


- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
}

@end
