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
#import "MKBuys.h"


@implementation MKTransactionProgressView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [NSColor whiteColor];
        
        [self setAutoresizesSubviews:NO];
        [self setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];
        
        
        _stepsView = [[MKStepsView alloc] initWithFrame:NSMakeRect(0, 0, self.width, 60)];
        [self addSubview:_stepsView];
        [_stepsView setThemePath:@"sell/title"];
        [_stepsView setDelegate:self];
        
        
        _statusView = [[MKStatusView alloc] initWithFrame:NSMakeRect(0, 0, self.width, 60*2)];
        _statusView.autoresizingMask = NSViewMinYMargin | NSViewMaxXMargin;
        [self addSubview:_statusView];
        [_statusView setThemePath:@"sell/price"];
        
        
        _bottomView = [[NavColoredView alloc] initWithFrame:NSMakeRect(0, 0, self.width, 100)];
        [_bottomView setAutoresizesSubviews:NO];
        _bottomView.backgroundColor = [NSColor whiteColor];
        [self addSubview:_bottomView];
        
        
        _maskView = [[NavColoredView alloc] initWithFrame:NSMakeRect(0, 0, self.width, 100)];
        _maskView.backgroundColor = [NSColor colorWithCalibratedWhite:0.5 alpha:1.0];
        _maskView.alphaValue = .05;
        
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
    [_stepsView layout];

    [_statusView placeYBelow:_stepsView margin:0.0];
    [_statusView setWidth:self.width];
    [_statusView layout];
    
    CGFloat h = 1000;
    CGFloat w = self.width;
    //
    
    [ _bottomView setX:0];
    [_bottomView  setWidth:self.width];
    
    [_bottomView setHeight:h];
    [_bottomView placeYBelow:_statusView margin:0.0];

    [_postView setX:0];
    [_postView setY:0];
    [_postView  setWidth:w];
    [_postView setHeight:h];
    
    [_maskView setWidth:w];
    [_maskView setHeight:h];
    [_postView layout];
}

- (void)prepareToDisplay
{
    [self layout];
    [self layout];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[MKPanelManager sharedPanelManager] setPanelReceiver:self];
    
    NSView *lastView = (NSView *)self.subviews.lastObject;
    NSLog(@"%@ %@ %@", self.className, self.node.className, lastView.className);
    //[self syncToNode]; // temporary
    
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
    
    // looks like a NavColumn is adding this nodeView - why?
    // here's a temp hack around it
    MKPost *mkPost = self.transaction.mkPost;
    [mkPost.nodeView removeFromSuperview];

    if (!_postView)
    {
        //_postView = (MKPostView *)self.transaction.mkPost.nodeView;
        
        _postView = [[MKPostView alloc] initWithFrame:self.frame];
        [_postView setNode:mkPost];
        BOOL isBuy = [self.node.nodeParent isKindOfClass:MKBuys.class];
        [_postView setEditable:!isBuy && !mkPost.postMsg];
        
        /*
        [_bottomView  setWidth:self.width];
        [_bottomView setHeight:1000];
        
        [_postView  setWidth:_bottomView.width];
        [_postView setHeight:_bottomView.height];
        */
        [_bottomView addSubview:_postView];
    }
    
    /*
    [_bottomView  setWidth:self.width];
    [_bottomView setHeight:1000];
    
    [_postView  setWidth:_bottomView.width];
    [_postView setHeight:_bottomView.height];
    */
    
    if (_postView.editable)
    {
        _postView.alphaValue = 1;
        [_maskView removeFromSuperview];
    }
    else
    {
        _postView.alphaValue = .5;
        [_bottomView addSubview:_maskView];
    }
    
    [self layout];
}

- (void)syncToNode
{
    //[self.transaction postSelfChanged];
}

@end
