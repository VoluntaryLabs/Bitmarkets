//
//  MKBidMsgView.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <NavKit/NavKit.h>

@interface MKBidMsgView : NSView

@property (assign, nonatomic) NavView *navView;
@property (assign, nonatomic) NavNode *node;

@end
