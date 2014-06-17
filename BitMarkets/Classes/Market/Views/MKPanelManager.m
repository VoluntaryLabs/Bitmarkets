//
//  MKPanelManager.m
//  BitMarkets
//
//  Created by Steve Dekorte on 6/17/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKPanelManager.h"
#import "MKPanelView.h"

@implementation MKPanelManager

static MKPanelManager *sharedPanelManager = nil;

+ (MKPanelManager *)sharedPanelManager
{
    if (!sharedPanelManager)
    {
        sharedPanelManager = [[MKPanelManager alloc] init];
    }
    
    return sharedPanelManager;
}

- (void)setPanelReceiver:(NSView *)panelReceiver
{
    _panelReceiver = panelReceiver;
}

- (MKPanelView *)receiverPanelView
{
    if (_panelReceiver)
    {
        for (NSView *subview in _panelReceiver.subviews)
        {
            if ([subview isKindOfClass:MKPanelView.class])
            {
                return (MKPanelView *)subview;
            }
        }
    }
    
    return nil;
}

- (MKPanelView *)openNewPanel
{
    if (_panelReceiver && !self.receiverPanelView)
    {
        MKPanelView *panelView = [[MKPanelView alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
        [_panelReceiver addSubview:panelView];
        [panelView layout];
        return panelView;
    }
    else
    {
        [NSException raise:@"no panel receiver" format:nil];
    }
    
    return nil;
}

@end
