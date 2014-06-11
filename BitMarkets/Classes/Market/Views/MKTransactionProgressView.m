//
//  MKTransactionProgressView.m
//  BitMarkets
//
//  Created by Steve Dekorte on 6/4/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKTransactionProgressView.h"
#import "MKStepsView.h"
#import <NavKit/NavKit.h>


@implementation MKTransactionProgressView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setAutoresizesSubviews:YES];
        [self setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];
        
        _stepsView = [[MKStepsView alloc] initWithFrame:NSMakeRect(0, 0, self.width, 100)];
        [self addSubview:_stepsView];
        [_stepsView setThemePath:@"sell/title"];
        [_stepsView setDelegate:self];
        //@property (strong) IBOutlet NSTextView *quantity;
        
        _statusView = [[NavAdvTextView alloc] initWithFrame:NSMakeRect(0, 0, self.width, 100)];
        _statusView.autoresizingMask = NSViewMinYMargin | NSViewMaxXMargin;
        [self addSubview:_statusView];
        [_statusView setThemePath:@"sell/price"];
        
  
        _bottomView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, self.width, 100)];
        
    }
    
    return self;
}

- (void)layout
{    
    [_stepsView placeInTopOfSuperviewWithMargin:0];
    [_stepsView setWidth:self.width];
    
    [_statusView placeYBelow:_stepsView margin:0.0];
    [_statusView setWidth:self.width];
    
    [_bottomView placeYBelow:_statusView margin:0.0];
    [_bottomView setWidth:self.width];
}

- (void)prepareToDisplay
{
    [self layout];
    [self layout];
}

- (void)setFrame:(NSRect)frameRect
{
    [super setFrame:frameRect];
    [self layout];
}

- (void)setNode:(NavNode *)node
{
    _node = node;
    
    [self syncFromNode];
}

- (MKTransaction *)transaction
{
    return (MKTransaction *)self.node;
}

- (void)syncFromNode
{

}

- (void)syncToNode
{

    [self.transaction postSelfChanged];
}

@end
