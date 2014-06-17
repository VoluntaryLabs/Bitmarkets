//
//  MKPanelManager.h
//  BitMarkets
//
//  Created by Steve Dekorte on 6/17/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKPanelView.h"

@interface MKPanelManager : NSObject

@property (strong, nonatomic) NSView *panelReceiver;

+ (MKPanelManager *)sharedPanelManager;

- (MKPanelView *)openNewPanel;

@end
