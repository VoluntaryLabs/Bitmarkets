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
#import "MKPanelManager.h"


@implementation MKTransactionProgressView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [NSColor whiteColor];
        
        //[self setAutoresizesSubviews:YES];
        [self setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];
        
        
        _stepsView = [[MKStepsView alloc] initWithFrame:NSMakeRect(0, 0, self.width, 60)];
        [self addSubview:_stepsView];
        [_stepsView setThemePath:@"sell/title"];
        [_stepsView setDelegate:self];
        
        
        _statusView = [[MKStatusView alloc] initWithFrame:NSMakeRect(0, 0, self.width, 60*2)];
        _statusView.autoresizingMask = NSViewMinYMargin | NSViewMaxXMargin;
        [self addSubview:_statusView];
        [_statusView setThemePath:@"sell/price"];
        
        
        _bottomView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, self.width, 100)];
        [self addSubview:_bottomView];
        
        
        _maskView = [[NavColoredView alloc] initWithFrame:NSMakeRect(0, 0, self.width, 100)];
        //_maskView.backgroundColor = [NSColor redColor];
        _maskView.backgroundColor = [NSColor colorWithCalibratedWhite:0.5 alpha:1.0];
        _maskView.alphaValue = .05;
       // [_maskView setOp:NO];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(walletChanged:)
                                                     name:@"WalletChanged"
                                                   object:nil];
    }
    
    return self;
}

- (void)walletChanged:(NSNotification *)aNote
{
    [self syncToNode];
}

- (void)layout
{    
    [_stepsView placeInTopOfSuperviewWithMargin:0];
    [_stepsView setWidth:self.width];
    
    [_statusView placeYBelow:_stepsView margin:0.0];
    [_statusView setWidth:self.width];
    
    [_bottomView placeYBelow:_statusView margin:0.0];
    [_bottomView setWidth:self.width];
    
    [_maskView setWidth:_bottomView.width];
    [_maskView setHeight:_bottomView.height];
    
    [self.stepsView layout];
    [self.statusView layout];
}

- (void)prepareToDisplay
{
    [self layout];
    [self layout];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[MKPanelManager sharedPanelManager] setPanelReceiver:self];
    
    [self syncToNode]; // temporary
    
    [super drawRect:dirtyRect];
}

- (MKTransaction *)transaction
{
    return (MKTransaction *)self.node;
}

- (void)setNode:(NavNode *)node
{
    [_stepsView  setNode:node];
    [_statusView setNode:node];
    [super setNode:node];
}

- (void)syncFromNode
{
    [_stepsView  syncFromNode];
    [_statusView syncFromNode];
    
    [_bottomView removeAllSubviews];
    
    MKPostView *postView = (MKPostView *)self.transaction.mkPost.nodeView;
    //[_bottomView setBounds:postView.bounds];
    
    [_bottomView  setWidth:self.width];
    [_bottomView setHeight:1000];
    
    [postView  setWidth:_bottomView.width];
    [postView setHeight:_bottomView.height];
    
    [_bottomView addSubview:postView];
    
    if (postView.editable)
    {
        postView.alphaValue = 1;
    }
    else
    {
        postView.alphaValue = .5;
        [_bottomView addSubview:_maskView];
    }
    
    [self layout];
}

- (void)syncToNode
{
    //[self.transaction postSelfChanged];
}

@end
