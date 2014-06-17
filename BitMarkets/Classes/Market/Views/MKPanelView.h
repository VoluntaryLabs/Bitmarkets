//
//  MKPanelView.h
//  BitMarkets
//
//  Created by Steve Dekorte on 6/16/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <NavKit/NavKit.h>

@interface MKPanelView : NSView

@property (strong, nonatomic) NSView *innerView;

@end
