//
//  MKBuyBid.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKBuyBid.h"
#import "MKMsg.h"
#import "MKBidMsg.h"
#import "MKAcceptBidMsg.h"

@implementation MKBuyBid

- (id)init
{
    self = [super init];
    return self;
}

// --- titles -------------

- (CGFloat)nodeSuggestedWidth
{
    return 350;
}

- (NSString *)nodeTitle
{
    return @"Bid";
}

- (NSString *)nodeNote
{
    if (self.children.count > 0)
    {
        return @"✓";
    }
    
    return nil;
}

// --- messages -------------

- (BOOL)handleMsg:(MKMsg *)msg
{
    if ([msg isKindOfClass:MKBidMsg.class])
    {
        [self addChild:msg];
        return YES;
    }
    
    if ([msg isKindOfClass:MKAcceptBidMsg.class])
    {
        [self addChild:msg];
        return YES;
    }
    
    return NO;
}

@end
