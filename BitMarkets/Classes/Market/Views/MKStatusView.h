//
//  MKStatusView.h
//  BitMarkets
//
//  Created by Steve Dekorte on 6/12/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <NavKit/NavKit.h>

@interface MKStatusView : NavColoredView

//@property (strong, nonatomic) NSView *buttonsView;
@property (strong, nonatomic) NavColoredView *buttonsView;

@property (assign, nonatomic) NavNode *node;
@property (strong, nonatomic) NavTextView *statusTextView;
@property (strong, nonatomic) NavTextView *subtitleTextView;

@end
