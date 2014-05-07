//
//  MKSellBids.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKSellBids.h"
#import "MKMsg.h"
#import "MKBidMsg.h"
#import "MKAcceptBidMsg.h"

@implementation MKSellBids

- (id)init
{
    self = [super init];
    self.shouldUseCountForNodeNote = YES;
    return self;
}

- (NSString *)nodeTitle
{
    return @"Bids";
}

- (CGFloat)nodeSuggestedWidth
{
    return 350.0;
}

- (NSString *)nodeNote
{
    if (self.children.count > 0)
    {
        return @"✓";
    }
    
    return nil;
}

- (NSString *)nodeSubtitle
{
    if (self.children.count > 0)
    {
        return @"choose bid";
    }
    
    return nil;
}

- (BOOL)handleMsg:(MKMsg *)msg
{
    if ([msg isKindOfClass:MKBidMsg.class])
    {
        [self addChild:msg];
        return YES;
    }
    
    return NO;
}

@end
