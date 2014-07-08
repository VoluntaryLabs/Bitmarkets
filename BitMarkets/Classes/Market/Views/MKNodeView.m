//
//  MKNodeView.m
//  BitMarkets
//
//  Created by Steve Dekorte on 6/16/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKNodeView.h"

@implementation MKNodeView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [NSColor whiteColor];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setFrame:(NSRect)frameRect
{
    [super setFrame:frameRect];
    [self layout];
}

- (void)layout
{
    
}

- (void)setNode:(NavNode *)node
{
    if (_node != node)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:_node];
        _node = node;
        if (_node)
        {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(nodeChanged:)
                                                         name:nil
                                                       object:_node];
            [self syncFromNode];
        }
    }
}

- (void)nodeChanged:(NSNotification *)aNote
{
    [self syncFromNode];
}

- (void)syncFromNode
{
    
}

@end
