//
//  MKStatusView.h
//  BitMarkets
//
//  Created by Steve Dekorte on 6/12/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MKNodeView.h"

@interface MKStatusView : MKNodeView

@property (strong, nonatomic) NavColoredView *buttonsView;
@property (strong, nonatomic) NavTextView *statusTextView;
@property (strong, nonatomic) NavTextView *subtitleTextView;
@property (strong, nonatomic) NSString *title;

@property (assign, nonatomic) SEL titleSelector;
@property (assign, nonatomic) SEL subtitleSelector;


- (NSDictionary *)nodeTitleAttributes;
- (void)setupButtons;

@end
