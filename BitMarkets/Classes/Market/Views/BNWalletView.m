//
//  BNWalletView.m
//  BitMarkets
//
//  Created by Steve Dekorte on 6/26/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "BNWalletView.h"
#import "MKPanelManager.h"

@implementation BNWalletView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _statusView = [[MKStatusView alloc] initWithFrame:NSMakeRect(0, 0, self.width, 60*2)];
        _statusView.title = @"Balance";
        _statusView.autoresizingMask = NSViewMaxXMargin;
        [self addSubview:_statusView];
        [_statusView setThemePath:@"sell/price"];
        
        _tableView = [[MKTableView alloc] initWithFrame:NSMakeRect(0, 0, self.width, 60*2)];
        _tableView.autoresizingMask = NSViewMinYMargin | NSViewMaxXMargin;
    }
    
    return self;
}

- (void)layout
{
    [_statusView setX:0];
    [_statusView setY:self.height - _statusView.height];
    [_statusView setWidth:self.width];
    [_statusView layout];
    
    [_tableView setHeight:_statusView.y];
    [_tableView placeYBelow:_statusView margin:0];
    [_tableView setX:0];
}

- (void)syncFromNode
{
    [_statusView setNode:self.node];
    [_statusView syncFromNode];
    
    [self layout];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[MKPanelManager sharedPanelManager] setPanelReceiver:self];
    
    [super drawRect:dirtyRect];
}


@end
